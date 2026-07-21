-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.prisma",
    callback = function()
        vim.bo.filetype = "prisma"
    end
})

local four_space_indent = vim.api.nvim_create_augroup("four_space_indent", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "FileType", "BufWritePre" }, {
    group = four_space_indent,
    pattern = "*",
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
        vim.bo.softtabstop = 4
        vim.bo.expandtab = true
    end,
})

-- Auto save files when leaving insert mode or losing focus
vim.api.nvim_create_autocmd({"InsertLeave", "TextChanged", "FocusLost"}, {
    pattern = "*",
    callback = function()
        if vim.bo.modified and vim.bo.buftype == "" and vim.fn.expand("%") ~= "" then
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

-- Force line wrap for diagnostic popups
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = args.buf,
            callback = function()
                local _, winid = vim.diagnostic.open_float(nil, {
                    focusable = false,
                    close_events = {"CursorMoved", "CursorMovedI", "BufLeave", "InsertEnter"},
                    border = "rounded",
                    source = "always",
                    prefix = " ",
                    scope = "line"
                })
                if winid then
                    vim.wo[winid].wrap = true
                end
            end
        })
    end
})

-- Ensure floating windows for diagnostics wrap text
vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
        if vim.api.nvim_win_get_config(0).relative ~= "" then
            vim.wo.wrap = true
        end
    end
})
