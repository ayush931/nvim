local map = vim.keymap.set

map("n", "<leader>ww", "<cmd>w<cr>", {
    desc = "Save File"
})
map("n", "<leader>wq", "<cmd>wq<cr>", {
    desc = "Save and Quit"
})
map("n", "<leader>qq", "<cmd>qa<cr>", {
    desc = "Quit All"
})

map("n", "<leader>un", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {
    desc = "Toggle Relative Number"
})

map("n", "<leader>uw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.wo.linebreak = vim.wo.wrap
    vim.wo.breakindent = vim.wo.wrap
end, {
    desc = "Toggle Word Wrap"
})

map("n", "<leader>cp", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    vim.notify("Copied absolute path", vim.log.levels.INFO)
end, {
    desc = "Copy File Absolute Path"
})

map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({
        bufnr = 0
    })
    vim.lsp.inlay_hint.enable(not enabled, {
        bufnr = 0
    })
end, {
    desc = "Toggle Inlay Hints"
})

map("n", "gl", function()
    local has_saga, saga = pcall(require, "lspsaga.diagnostic")
    if has_saga and saga then
        vim.cmd("Lspsaga show_line_diagnostics ++unfocus")
    else
        vim.diagnostic.open_float(nil, {
            border = "rounded",
            source = "always",
            focusable = false,
            max_width = 120,
            max_height = 30,
            wrap = true,
            close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        })
    end
end, {
    desc = "Show Full Line Diagnostics & Suggestions"
})

-- Disable automatic LSP signature help popup while typing (e.g. vector, std library functions)
vim.g.auto_signature_help = false

local orig_sig_help = vim.lsp.handlers["textDocument/signatureHelp"]
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    if ctx and ctx.params and ctx.params.context then
        local kind = ctx.params.context.triggerKind
        -- Suppress automatic triggers from typing '(' or ',' or editing (triggerKind 2 or 3)
        if (kind == 2 or kind == 3) and not vim.g.auto_signature_help then
            return
        end
    end
    if orig_sig_help then
        return orig_sig_help(err, result, ctx, config)
    end
end

-- Keybinding to toggle automatic signature help popups on/off
map("n", "<leader>us", function()
    vim.g.auto_signature_help = not vim.g.auto_signature_help
    local status = vim.g.auto_signature_help and "Enabled" or "Disabled"
    vim.notify("Auto Signature Help Popup: " .. status, vim.log.levels.INFO)
end, {
    desc = "Toggle Auto Signature Help Popup"
})

-- Manual signature help trigger in Insert mode (<C-k>)
map("i", "<C-k>", function()
    local has_saga, _ = pcall(require, "lspsaga.signaturehelp")
    if has_saga then
        vim.cmd("Lspsaga signature_help")
    else
        vim.lsp.buf.signature_help()
    end
end, {
    desc = "Toggle Signature Help / Definition"
})

