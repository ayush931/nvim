-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`

-- Filetype detection for Prisma
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.prisma",
    callback = function()
        vim.bo.filetype = "prisma"
    end
})

-- Auto-create missing parent directories when saving a new file
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(event)
        if not event.file or event.file == "" or event.file:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local dir = vim.fn.fnamemodify(event.file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})

-- Style comments with softer grey tone (no italics)
vim.api.nvim_create_autocmd({ "ColorScheme", "VimEnter" }, {
    callback = function()
        vim.api.nvim_set_hl(0, "Comment", { fg = "#556272" })
    end,
})


-- Auto save files when leaving insert mode or losing focus
vim.api.nvim_create_autocmd({"InsertLeave", "FocusLost"}, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and not vim.bo.readonly and vim.bo.modifiable and vim.fn.expand("%") ~= "" then
            vim.cmd("silent! write")
        end
    end
})

-- Enable inlay hints when LSP attaches to a buffer (with sensible exclusions)
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client or not client:supports_method("textDocument/inlayHint") then
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

        -- Only enable inlay hints if globally enabled
        local global_enabled = false
        if vim.g.lsp_inlay_hints_enabled ~= nil then
            global_enabled = vim.g.lsp_inlay_hints_enabled
        else
            -- fallback to opts in plugins/lsp.lua if available
            local ok, lspconfig = pcall(require, "plugins.lsp")
            if ok and lspconfig and lspconfig[1] and lspconfig[1].opts and lspconfig[1].opts.inlay_hints then
                global_enabled = lspconfig[1].opts.inlay_hints.enabled
            end
        end
        vim.lsp.inlay_hint.enable(global_enabled, {
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

-- Ensure floating windows for diagnostics and peek definitions wrap text and close cleanly on q / <Esc>
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(winid)
        if config.relative ~= "" then
            vim.wo[winid].wrap = true
            local bufnr = vim.api.nvim_win_get_buf(winid)
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr, silent = true, nowait = true })
            vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = bufnr, silent = true, nowait = true })
        end
    end
})

-- Auto-show diagnostics (errors, warnings, and quick fixes) in a floating box on CursorHold
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        if vim.api.nvim_get_mode().mode ~= "n" then
            return
        end

        -- Check if a floating window is already open
        for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).relative ~= "" then
                return
            end
        end

        -- Only trigger if there are diagnostics on the current line
        local line = vim.api.nvim_win_get_cursor(0)[1] - 1
        local bufnr = vim.api.nvim_get_current_buf()
        local diagnostics = vim.diagnostic.get(bufnr, { lnum = line })
        if #diagnostics > 0 then
            local has_saga, _ = pcall(require, "lspsaga.diagnostic")
            if has_saga then
                vim.cmd("Lspsaga show_line_diagnostics ++unfocus")
            else
                vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = { "CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter", "FocusLost" },
                    border = "rounded",
                    source = "always",
                })
            end
        end
    end,
})
