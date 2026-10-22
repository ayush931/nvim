local group = vim.api.nvim_create_augroup("ConfigAutocmds", { clear = true })

-- Save only ordinary, writable files when focus leaves Neovim.
vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function(event)
        local buf = event.buf
        if
            vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].modified
            and vim.bo[buf].buftype == ""
            and not vim.bo[buf].readonly
            and vim.bo[buf].modifiable
            and vim.api.nvim_buf_get_name(buf) ~= ""
        then
            vim.api.nvim_buf_call(buf, function()
                local ok, err = pcall(vim.cmd.write)
                if not ok then
                    vim.notify("Auto-save failed: " .. tostring(err), vim.log.levels.ERROR)
                end
            end)
        end
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = group,
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

vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
    group = group,
    callback = function()
        vim.opt_local.formatoptions:remove("cro")
    end,
})

require("config.diagnostics").setup()
