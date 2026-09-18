-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Auto save files only when losing focus (prevent formatting lag during active editing)
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        if vim.api.nvim_buf_is_valid(bufnr)
            and vim.bo[bufnr].modified
            and vim.bo[bufnr].buftype == ""
            and not vim.bo[bufnr].readonly
            and vim.bo[bufnr].modifiable
            and vim.api.nvim_buf_get_name(bufnr) ~= ""
        then
            vim.cmd("silent! write")
        end
    end
})

-- C-like 4-space settings for filetypes without a dedicated ftplugin file
-- (c/cpp live once in after/ftplugin/c.lua and after/ftplugin/cpp.lua).
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "cuda", "objc", "objcpp", "proto" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = true
        vim.opt_local.cindent = true
        vim.opt_local.cinoptions = "g0,N-s,j1,(0,ws,Ws"
    end,
})

-- Enable inlay hints when LSP attaches to a buffer (with defensive checks)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) then
            return
        end
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or client:is_stopped() then
            return
        end

        local ok, supports_hints = pcall(function()
            return client:supports_method("textDocument/inlayHint")
        end)
        if not ok or not supports_hints then
            return
        end

        local ft = vim.bo[args.buf].filetype
        local excluded = {
            markdown = true,
            text = true,
            gitcommit = true
        }
        if excluded[ft] then
            return
        end

        local global_enabled = vim.g.lsp_inlay_hints_enabled == true
        pcall(vim.lsp.inlay_hint.enable, global_enabled, {
            bufnr = args.buf
        })
    end
})

-- Ensure comments do not automatically continue on new lines for any filetype (Enter or o/O)
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter", "FileType" }, {
    pattern = "*",
    callback = function()
        vim.opt_local.formatoptions:remove("cro")
    end,
})

-- Ensure floating windows for diagnostics, suggestions, hover, and peek definitions wrap text cleanly and stay fully visible
local float_no_wrap_ft = {
    ["which-key"] = true,
    ["TelescopePrompt"] = true,
    ["TelescopeResults"] = true,
    ["neo-tree"] = true,
    ["toggleterm"] = true,
    ["blink-cmp-menu"] = true,
    ["snacks_picker_input"] = true,
    ["snacks_picker_list"] = true,
}

local float_close_ignore_ft = {
    ["which-key"] = true,
    ["TelescopePrompt"] = true,
    ["TelescopeResults"] = true,
    ["neo-tree"] = true,
    ["toggleterm"] = true,
    ["blink-cmp-menu"] = true,
    ["blink-cmp-documentation"] = true,
    ["snacks_picker_input"] = true,
    ["snacks_picker_list"] = true,
    ["notify"] = true,
    ["lazy"] = true,
    ["mason"] = true,
    ["Trouble"] = true,
    ["trouble"] = true,
    ["oil"] = true,
}

local function adjust_float_window(winid)
    if not winid or not vim.api.nvim_win_is_valid(winid) then
        return
    end
    local ok, config = pcall(vim.api.nvim_win_get_config, winid)
    if not ok or not config or config.relative == "" then
        return
    end
    local bufnr = vim.api.nvim_win_get_buf(winid)
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    local ft = vim.bo[bufnr].filetype
    local bt = vim.bo[bufnr].buftype

    if float_no_wrap_ft[ft] or bt == "prompt" or bt == "terminal" then
        return
    end

    -- Word-wrap the box so long errors/warnings/suggestions stay fully visible inside the float
    vim.wo[winid].wrap = true
    vim.wo[winid].linebreak = true
    vim.wo[winid].breakindent = true
    vim.wo[winid].breakindentopt = "shift:2,min:20"

    -- Expand box height if needed so wrapped lines are completely visible without cutting off
    local width = config.width or vim.api.nvim_win_get_width(winid)
    if width and width > 0 then
        local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
        if #lines > 0 then
            local total_rows = 0
            for _, line in ipairs(lines) do
                local w = vim.fn.strdisplaywidth(line)
                total_rows = total_rows + math.max(1, math.ceil(w / width))
            end
            local max_avail = math.floor(vim.o.lines * 0.85)
            local target_h = math.min(total_rows, max_avail)
            if target_h > (config.height or 0) then
                pcall(vim.api.nvim_win_set_config, winid, { height = target_h })
            end
        end
    end

    -- Attach copy and close mappings to the float buffer so user can easily copy errors
    if not float_close_ignore_ft[ft] and (bt ~= "" or not vim.bo[bufnr].modifiable) then
        if not vim.b[bufnr]._float_copy_mapped then
            vim.b[bufnr]._float_copy_mapped = true

            -- 'y' in normal mode copies the entire error/diagnostic text to clipboard
            vim.keymap.set("n", "y", function()
                local float_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local text = table.concat(float_lines, "\n")
                vim.fn.setreg("+", text)
                vim.fn.setreg('"', text)
                vim.notify("Copied error to clipboard", vim.log.levels.INFO)
            end, { buffer = bufnr, silent = true, nowait = true, desc = "Copy Error to Clipboard" })

            -- 'Y' copies the entire error/box content to clipboard
            vim.keymap.set("n", "Y", function()
                local float_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                local text = table.concat(float_lines, "\n")
                vim.fn.setreg("+", text)
                vim.fn.setreg('"', text)
                vim.notify("Copied error to clipboard", vim.log.levels.INFO)
            end, { buffer = bufnr, silent = true, nowait = true, desc = "Copy Entire Box Content" })

            -- 'yy' copies the single line under cursor in the box
            vim.keymap.set("n", "yy", function()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local line = vim.api.nvim_buf_get_lines(bufnr, cursor[1] - 1, cursor[1], false)[1] or ""
                vim.fn.setreg("+", line)
                vim.fn.setreg('"', line)
                vim.notify("Copied line to clipboard", vim.log.levels.INFO)
            end, { buffer = bufnr, silent = true, nowait = true, desc = "Copy Current Line" })

            -- Ctrl-c copies in normal and visual modes
            vim.keymap.set({"n", "v"}, "<C-c>", function()
                local mode = vim.api.nvim_get_mode().mode
                if mode:match("[vV\22]") then
                    vim.cmd('normal! "+y')
                    vim.notify("Copied selection to clipboard", vim.log.levels.INFO)
                else
                    local float_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
                    local text = table.concat(float_lines, "\n")
                    vim.fn.setreg("+", text)
                    vim.fn.setreg('"', text)
                    vim.notify("Copied error to clipboard", vim.log.levels.INFO)
                end
            end, { buffer = bufnr, silent = true, nowait = true, desc = "Copy to Clipboard" })

            -- Visual mode 'y' copies selection to clipboard
            vim.keymap.set("v", "y", function()
                vim.cmd('normal! "+y')
                vim.notify("Copied selection to clipboard", vim.log.levels.INFO)
            end, { buffer = bufnr, silent = true, nowait = true, desc = "Copy Selection" })

            -- Close cleanly on q / <Esc>
            vim.keymap.set("n", "q", function()
                local win = vim.api.nvim_get_current_win()
                local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
                if ok_cfg and cfg and cfg.relative ~= "" then
                    pcall(vim.api.nvim_win_close, win, false)
                else
                    pcall(vim.keymap.del, "n", "q", { buffer = bufnr })
                    vim.b[bufnr]._float_copy_mapped = false
                    vim.api.nvim_feedkeys("q", "n", false)
                end
            end, { buffer = bufnr, silent = true, nowait = true })

            vim.keymap.set("n", "<Esc>", function()
                local win = vim.api.nvim_get_current_win()
                local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
                if ok_cfg and cfg and cfg.relative ~= "" then
                    pcall(vim.api.nvim_win_close, win, false)
                else
                    pcall(vim.keymap.del, "n", "<Esc>", { buffer = bufnr })
                    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                end
            end, { buffer = bufnr, silent = true, nowait = true })
        end
    end
end

-- Hook both BufWinEnter (for unfocused/new floats) and WinEnter (for focused floats)
vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter" }, {
    callback = function(args)
        local winid = args.win or vim.api.nvim_get_current_win()
        adjust_float_window(winid)
        vim.schedule(function()
            adjust_float_window(winid)
        end)
    end
})

-- Track active diagnostic float to keep it open while on the same line and allow mouse/cursor interaction
local diag_float_win = nil
local diag_float_line = nil
local diag_float_buf = nil

-- Automatically pop up an interactive rounded box with word wrap on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
    group = vim.api.nvim_create_augroup("DiagnosticFloatCursorHold", { clear = true }),
    callback = function()
        if vim.api.nvim_get_mode().mode ~= "n" then
            return
        end
        local bufnr = vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) or vim.bo[bufnr].buftype ~= "" then
            return
        end

        local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

        -- Already open for this line in this buffer
        if diag_float_win and vim.api.nvim_win_is_valid(diag_float_win) then
            if diag_float_line == lnum and diag_float_buf == bufnr then
                return
            end
            pcall(vim.api.nvim_win_close, diag_float_win, true)
            diag_float_win = nil
        end

        -- Don't open if another popup/menu (Telescope, WhichKey, etc.) is visible
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            local ok_cfg, cfg = pcall(vim.api.nvim_win_get_config, win)
            if ok_cfg and cfg and cfg.relative ~= "" and win ~= diag_float_win then
                return
            end
        end

        local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
        if #diags == 0 then
            return
        end

        local fbuf, fwin = vim.diagnostic.open_float(bufnr, {
            scope = "line",
            focusable = true,
            focus = false,
            border = "rounded",
            header = "",
            prefix = "",
            source = "always",
            wrap = true,
            max_width = math.min(100, math.max(60, math.floor(vim.o.columns * 0.85))),
            -- No CursorMoved here: allows clicking into the box and selecting text without vanishing
            close_events = { "BufLeave", "InsertEnter", "FocusLost" },
        })

        if fwin and vim.api.nvim_win_is_valid(fwin) then
            diag_float_win = fwin
            diag_float_line = lnum
            diag_float_buf = bufnr
        end
    end,
})

-- Close the diagnostic float only when moving away to a different line in the source buffer
vim.api.nvim_create_autocmd("CursorMoved", {
    group = "DiagnosticFloatCursorHold",
    callback = function()
        if not diag_float_win or not vim.api.nvim_win_is_valid(diag_float_win) then
            diag_float_win = nil
            return
        end
        local curwin = vim.api.nvim_get_current_win()
        -- User is inside the float window (reading, selecting, copying) -> keep open!
        if curwin == diag_float_win then
            return
        end
        local curbuf = vim.api.nvim_get_current_buf()
        local curline = vim.api.nvim_win_get_cursor(0)[1] - 1
        if curbuf ~= diag_float_buf or curline ~= diag_float_line then
            pcall(vim.api.nvim_win_close, diag_float_win, true)
            diag_float_win = nil
        end
    end,
})
