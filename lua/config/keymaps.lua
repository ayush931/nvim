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

-- Copy line diagnostics (errors / warnings / suggestions) to the clipboard.
-- The float itself is focusable + wrapped, so you can also open it (<leader>cD),
-- visually select any part and yank; this shortcut skips the float entirely.
local function copy_line_diags()
    local bufnr = vim.api.nvim_get_current_buf()
    if not vim.api.nvim_buf_is_valid(bufnr) then
        return
    end
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
    if #diags == 0 then
        vim.notify("No diagnostics on this line", vim.log.levels.INFO)
        return
    end
    table.sort(diags, function(a, b)
        return a.severity < b.severity
    end)
    local lines = {}
    for _, d in ipairs(diags) do
        local sev = (vim.diagnostic.severity[d.severity] or "UNKNOWN"):lower()
        local src = d.source and (" (" .. d.source .. ")") or ""
        local code = d.code and (" [" .. tostring(d.code) .. "]") or ""
        table.insert(lines, string.format("[%s]%s%s: %s", sev, src, code, d.message))
    end
    local text = table.concat(lines, "\n")
    vim.fn.setreg("+", text)
    vim.fn.setreg('"', text)
    vim.notify("Copied " .. #diags .. " diagnostic(s) to clipboard", vim.log.levels.INFO)
end
map("n", "<leader>cy", copy_line_diags, {
    desc = "Copy Line Diagnostics to Clipboard"
})
map("n", "<leader>ce", copy_line_diags, {
    desc = "Copy Line Errors to Clipboard"
})
map("n", "<leader>cd", function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diags = vim.diagnostic.get(bufnr, { lnum = lnum })
    if #diags == 0 then
        vim.notify("No diagnostics on this line", vim.log.levels.INFO)
        return
    end
    local fbuf, fwin = vim.diagnostic.open_float(bufnr, {
        scope = "line",
        focus = true,
        focusable = true,
        border = "rounded",
        header = "",
        prefix = "",
        source = "always",
        wrap = true,
        max_width = math.min(100, math.max(60, math.floor(vim.o.columns * 0.85))),
        close_events = { "BufLeave", "InsertEnter", "FocusLost" },
    })
    if fwin and vim.api.nvim_win_is_valid(fwin) then
        pcall(vim.api.nvim_set_current_win, fwin)
    end
end, {
    desc = "Line Diagnostics Box (Focus & Copyable)"
})

map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({
        bufnr = 0
    })
    local new_state = not enabled
    vim.g.lsp_inlay_hints_enabled = new_state
    vim.lsp.inlay_hint.enable(new_state, {
        bufnr = 0
    })
    vim.notify("Inlay hints " .. (new_state and "enabled" or "disabled"), vim.log.levels.INFO)
end, {
    desc = "Toggle Inlay Hints"
})


-- Disable automatic LSP signature help popup while typing (e.g. vector, std library functions)
vim.g.auto_signature_help = false

local orig_sig_help = vim.lsp.handlers["textDocument/signatureHelp"] or vim.lsp.handlers.signature_help
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    if ctx and ctx.params and ctx.params.context then
        local kind = ctx.params.context.triggerKind
        -- Suppress automatic triggers from typing '(' or ',' or editing (triggerKind 2 or 3)
        if (kind == 2 or kind == 3) and not vim.g.auto_signature_help then
            return
        end
    end
    if orig_sig_help and orig_sig_help ~= vim.lsp.handlers["textDocument/signatureHelp"] then
        return orig_sig_help(err, result, ctx, config)
    elseif vim.lsp.handlers.signature_help and vim.lsp.handlers.signature_help ~= vim.lsp.handlers["textDocument/signatureHelp"] then
        return vim.lsp.handlers.signature_help(err, result, ctx, config)
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


