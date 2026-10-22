local map = vim.keymap.set

map("n", "<leader>ww", "<cmd>w<cr>", {
    desc = "Save File",
})
map("n", "<leader>wq", "<cmd>wq<cr>", {
    desc = "Save and Quit",
})
map("n", "<leader>qq", "<cmd>qa<cr>", {
    desc = "Quit All",
})

map("n", "<leader>un", function()
    vim.opt.relativenumber = not vim.opt.relativenumber:get()
end, {
    desc = "Toggle Relative Number",
})

map("n", "<leader>uw", function()
    vim.wo.wrap = not vim.wo.wrap
    vim.wo.linebreak = vim.wo.wrap
    vim.wo.breakindent = vim.wo.wrap
end, {
    desc = "Toggle Word Wrap",
})

map("n", "<leader>cp", function()
    vim.fn.setreg("+", vim.fn.expand("%:p"))
    vim.notify("Copied absolute path", vim.log.levels.INFO)
end, {
    desc = "Copy File Absolute Path",
})

-- Copy line diagnostics (errors / warnings / suggestions) to the clipboard.
-- The float itself is focusable + wrapped, so you can also open it (<leader>cd),
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
    desc = "Copy Line Diagnostics to Clipboard",
})
map("n", "<leader>ce", copy_line_diags, {
    desc = "Copy Line Errors to Clipboard",
})
map("n", "<leader>cd", function()
    require("config.diagnostics").open(true)
end, { desc = "Line Diagnostics Box (Focus & Copyable)" })

map("n", "<leader>uh", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({
        bufnr = 0,
    })
    local new_state = not enabled
    vim.lsp.inlay_hint.enable(new_state, {
        bufnr = 0,
    })
    vim.notify("Inlay hints " .. (new_state and "enabled" or "disabled"), vim.log.levels.INFO)
end, {
    desc = "Toggle Inlay Hints",
})

-- Blink owns automatic signature help; manual LSP help remains available.
map("n", "<leader>us", function()
    local signature = require("blink.cmp.config").signature
    signature.trigger.enabled = not signature.trigger.enabled
    if not signature.trigger.enabled then
        require("blink.cmp").hide_signature()
    end
    vim.notify("Auto Signature Help Popup: " .. (signature.trigger.enabled and "Enabled" or "Disabled"))
end, { desc = "Toggle Auto Signature Help Popup" })
