-- Run with the installed plugins and tools:
-- XDG_STATE_HOME=/tmp/nvim-check/state XDG_CACHE_HOME=/tmp/nvim-check/cache \
--   nvim --headless -i NONE '+luafile tests/regression.lua'
local errors = {}
local notify = vim.notify
vim.notify = function(message, level, opts)
    if level == vim.log.levels.ERROR then
        errors[#errors + 1] = tostring(message)
    end
    return notify(message, level, opts)
end

local function check(condition, message)
    assert(condition, message)
end

local function run()
    vim.g.autoformat = false
    vim.opt.clipboard = ""
    require("lazyvim.config").load("keymaps")
    require("lazyvim.config").load("autocmds")
    local config_root = vim.fn.getcwd()
    for _, path in ipairs(vim.fn.glob(config_root .. "/**/*.lua", false, true)) do
        check(loadfile(path), "Lua syntax error: " .. path)
    end

    -- Exercise lazy-loaded configuration, including adapter and completion APIs.
    require("lazy").load({
        plugins = {
            "nvim-lspconfig",
            "blink.cmp",
            "lspsaga.nvim",
            "nvim-dap",
            "neotest",
            "telescope.nvim",
            "yanky.nvim",
            "toggleterm.nvim",
            "aerial.nvim",
            "refactoring.nvim",
            "nvim-surround",
            "nvim-autopairs",
            "oil.nvim",
        },
    })
    local signature = require("blink.cmp.config").signature
    check(signature.enabled and not signature.trigger.enabled, "signature defaults")
    local toggle = vim.fn.maparg("<leader>us", "n", false, true).callback
    check(type(toggle) == "function", "signature toggle missing")
    toggle()
    check(signature.trigger.enabled, "automatic signatures cannot be enabled")
    toggle()
    check(not signature.trigger.enabled, "automatic signatures cannot be disabled")
    require("telescope").load_extension("yank_history")
    check(type(require("telescope").extensions.yank_history.yank_history) == "function", "yank picker missing")

    -- Reloading custom autocmds must not multiply callbacks.
    dofile(config_root .. "/lua/config/autocmds.lua")
    local count = #vim.api.nvim_get_autocmds({ group = "ConfigAutocmds" })
    dofile(config_root .. "/lua/config/autocmds.lua")
    check(#vim.api.nvim_get_autocmds({ group = "ConfigAutocmds" }) == count, "duplicate autocmds on reload")

    -- A focusable diagnostic stays open when entered; movement closes it.
    vim.cmd.enew()
    local source_win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "first", "second" })
    local ns = vim.api.nvim_create_namespace("config-regression")
    vim.diagnostic.set(ns, buf, { { lnum = 0, col = 0, message = string.rep("diagnostic ", 30) } })
    require("config.diagnostics").open(true)
    local float = vim.api.nvim_get_current_win()
    check(float ~= source_win, "diagnostic did not receive focus")
    check(vim.api.nvim_win_get_config(float).relative ~= "", "diagnostic is not a float")
    check(vim.wo[float].wrap, "diagnostic does not wrap")
    vim.api.nvim_set_current_win(source_win)
    check(vim.api.nvim_win_is_valid(float), "diagnostic closed on focus change")
    vim.api.nvim_win_set_cursor(source_win, { 2, 0 })
    vim.api.nvim_exec_autocmds("CursorMoved", { buffer = buf })
    check(not vim.api.nvim_win_is_valid(float), "stale diagnostic did not close")
    vim.diagnostic.reset(ns, buf)
    vim.bo[buf].modified = false
    print("PASS plugin setup, mappings, reloads, diagnostic lifecycle")

    check(#errors == 0, table.concat(errors, "\n"))
end

vim.schedule(function()
    local ok, err = xpcall(run, debug.traceback)
    if not ok then
        io.stderr:write(tostring(err) .. "\n")
        vim.cmd("cquit 1")
    else
        print("ALL REGRESSION CHECKS PASSED")
        vim.cmd("qa!")
    end
end)
