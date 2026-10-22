local M = {}
local terminals = {}

function M.toggle(cmd, direction, size)
    local dir = _G.get_project_root()
    direction = direction or "float"
    local key = table.concat({ dir, cmd, direction }, "\n")
    local entry = terminals[key]
    if entry and entry.exited then
        -- Keep finished output available until the next invocation, then release
        -- both the buffer and toggleterm's registry entry before running again.
        entry.term:shutdown()
        terminals[key] = nil
        entry = nil
    end
    if not entry then
        entry = { exited = false }
        entry.term = require("toggleterm.terminal").Terminal:new({
            cmd = cmd,
            dir = dir,
            direction = direction,
            hidden = true, -- Keep command jobs out of the generic terminal toggle.
            close_on_exit = false,
            on_exit = function()
                entry.exited = true
            end,
        })
        terminals[key] = entry
    end
    entry.term:toggle(size, direction)
end

return M
