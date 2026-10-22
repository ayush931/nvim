local M = {}
local active

local function close()
    local previous = active
    active = nil
    if previous and vim.api.nvim_win_is_valid(previous.win) then
        vim.api.nvim_win_close(previous.win, true)
    end
end

function M.open(focus)
    local buf = vim.api.nvim_get_current_buf()
    if vim.bo[buf].buftype ~= "" or vim.api.nvim_get_mode().mode ~= "n" then
        return
    end
    local source_win = vim.api.nvim_get_current_win()
    local line = vim.api.nvim_win_get_cursor(source_win)[1] - 1
    if active and vim.api.nvim_win_is_valid(active.win) then
        if active.buf == buf and active.line == line and active.source_win == source_win then
            if focus then
                vim.api.nvim_set_current_win(active.win)
            end
            return
        end
        close()
    end
    -- Avoid competing with completion menus, pickers, and other floats.
    if not focus then
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(win).relative ~= "" then
                return
            end
        end
    end
    if #vim.diagnostic.get(buf, { lnum = line }) == 0 then
        if focus then
            vim.notify("No diagnostics on this line", vim.log.levels.INFO)
        end
        return
    end
    local float_buf, win = vim.diagnostic.open_float(buf, {
        scope = "line",
        focus = false,
        focusable = true,
        border = "rounded",
        header = "",
        prefix = "",
        source = "always",
        max_width = math.max(1, math.min(100, vim.o.columns - 4)),
        max_height = math.max(1, math.min(30, vim.o.lines - 4)),
        -- BufLeave would close the float when entering it to select/copy text.
        close_events = { "InsertEnter", "FocusLost", "BufHidden" },
    })
    if not win or not vim.api.nvim_win_is_valid(win) then
        return
    end
    active = { win = win, buf = buf, line = line, source_win = source_win }
    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.wo[win].breakindent = true
    local function copy_all()
        local text = table.concat(vim.api.nvim_buf_get_lines(float_buf, 0, -1, false), "\n")
        vim.fn.setreg('"', text)
        vim.fn.setreg("+", text)
    end
    -- Leave y/yy as ordinary operators so line and visual yanks work correctly.
    vim.keymap.set("n", "Y", copy_all, { buffer = float_buf, desc = "Copy Entire Diagnostic" })
    vim.keymap.set("n", "<C-c>", copy_all, { buffer = float_buf, desc = "Copy Entire Diagnostic" })
    vim.keymap.set("x", "<C-c>", '"+y', { buffer = float_buf, desc = "Copy Selection" })
    for _, key in ipairs({ "q", "<Esc>" }) do
        vim.keymap.set("n", key, close, { buffer = float_buf, desc = "Close Diagnostic" })
    end
    if focus then
        vim.api.nvim_set_current_win(win)
    end
end

function M.setup()
    close()
    local group = vim.api.nvim_create_augroup("ConfigDiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
        group = group,
        callback = function()
            M.open(false)
        end,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "WinEnter", "BufEnter" }, {
        group = group,
        callback = function()
            if not active then
                return
            end
            if not vim.api.nvim_win_is_valid(active.win) then
                active = nil
                return
            end
            local win = vim.api.nvim_get_current_win()
            if win == active.win then
                return
            end
            if
                win ~= active.source_win
                or vim.api.nvim_get_current_buf() ~= active.buf
                or vim.api.nvim_win_get_cursor(win)[1] - 1 ~= active.line
            then
                close()
            end
        end,
    })
    vim.api.nvim_create_autocmd("DiagnosticChanged", {
        group = group,
        callback = function(event)
            if active and active.buf == event.buf then
                close()
            end
        end,
    })
end

return M
