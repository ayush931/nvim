local M = {}

local function current_path()
    if vim.bo.buftype == "" then
        local name = vim.api.nvim_buf_get_name(0)
        if name ~= "" then
            return name
        end
    end
    return vim.fn.getcwd()
end

function M.root(path)
    path = path or current_path()
    return vim.fs.root(path, { ".git", "turbo.json", "package.json", "Makefile", "Cargo.toml", "go.mod" })
        or vim.fn.getcwd()
end

function M.workspace_dirs()
    local path = current_path()
    local root = vim.fs.root(path, { "turbo.json", "pnpm-workspace.yaml" }) or M.root(path)
    local dirs = {}
    for _, name in ipairs({ "packages", "apps" }) do
        local dir = root .. "/" .. name
        if vim.fn.isdirectory(dir) == 1 then
            dirs[#dirs + 1] = dir
        end
    end
    -- Ordinary projects still get a working picker instead of an rg error.
    if #dirs == 0 then
        dirs[1] = root
    end
    return root, dirs
end

return M
