-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Filetype detection for Prisma
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.prisma",
    callback = function()
        vim.bo.filetype = "prisma"
    end
})

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

-- C / C++ 4-space tab and indentation settings (expandtab, shiftwidth=4, tabstop=4, softtabstop=4)
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "c", "cpp", "cuda", "objc", "objcpp", "proto" },
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

-- Ensure floating windows for diagnostics and peek definitions wrap text and close cleanly on q / <Esc>
local float_ignore_ft = {
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

vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        local winid = vim.api.nvim_get_current_win()
        if not vim.api.nvim_win_is_valid(winid) then
            return
        end
        local ok, config = pcall(vim.api.nvim_win_get_config, winid)
        if not ok or not config or config.relative == "" then
            return
        end
        vim.wo[winid].wrap = true
        local bufnr = vim.api.nvim_win_get_buf(winid)
        if not vim.api.nvim_buf_is_valid(bufnr) then
            return
        end
        local ft = vim.bo[bufnr].filetype
        local bt = vim.bo[bufnr].buftype
        if not float_ignore_ft[ft] and bt ~= "prompt" and bt ~= "terminal" then
            if not vim.b[bufnr]._float_close_mapped then
                vim.b[bufnr]._float_close_mapped = true
                vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = bufnr, silent = true, nowait = true })
                vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = bufnr, silent = true, nowait = true })
            end
        end
    end
})
