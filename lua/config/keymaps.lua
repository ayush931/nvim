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
