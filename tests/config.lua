-- Run without plugins or background services:
-- nvim --headless -u NONE -i NONE -l tests/config.lua
package.path = vim.fn.getcwd() .. "/lua/?.lua;" .. package.path
for _, path in ipairs(vim.fn.glob("**/*.lua", false, true)) do
    assert(loadfile(path), "invalid Lua: " .. path)
end
for _, path in ipairs(vim.fn.glob("lua/plugins/*.lua", false, true)) do
    assert(type(dofile(path)) == "table", "invalid plugin spec: " .. path)
end

package.preload["telescope.themes"] = function()
    return {
        get_dropdown = function()
            return {}
        end,
    }
end
local telescope = dofile("lua/plugins/telescope.lua")[1].opts(nil, {})
local function ignored(path)
    for _, pattern in ipairs(telescope.defaults.file_ignore_patterns) do
        if path:find(pattern) then
            return true
        end
    end
    return false
end
for _, path in ipairs({ "src/distance.ts", "src/building.lua", "src/next.config.js", "src/widget.lua" }) do
    assert(not ignored(path), "legitimate source hidden: " .. path)
end
for _, path in ipairs({ "dist/index.js", "app/node_modules/lib/index.js", ".git/config", "app/.next/cache" }) do
    assert(ignored(path), "generated directory visible: " .. path)
end
print("PASS Telescope directory filtering")

local project = require("config.project")
local root = vim.fn.tempname()
local package_dir = root .. "/packages/app"
vim.fn.mkdir(package_dir .. "/src", "p")
vim.fn.writefile({ "{}" }, root .. "/turbo.json")
vim.fn.writefile({ "{}" }, package_dir .. "/package.json")
vim.fn.writefile({ "export default {}" }, root .. "/jest.config.mjs")
local test_file = package_dir .. "/src/app.test.ts"
vim.fn.writefile({ "test('ok', () => {})" }, test_file)
vim.cmd.edit(test_file)
local workspace, dirs = project.workspace_dirs()
assert(workspace == root and #dirs == 1 and dirs[1] == root .. "/packages", "workspace search roots")
-- An ordinary repository with no monorepo ancestor falls back to its root.
local standalone = vim.fn.tempname()
vim.fn.mkdir(standalone .. "/.git", "p")
vim.fn.writefile({ "{}" }, standalone .. "/package.json")
vim.cmd.edit(standalone .. "/index.ts")
workspace, dirs = project.workspace_dirs()
assert(
    workspace == standalone and #dirs == 1 and dirs[1] == standalone,
    "ordinary project search fallback: "
        .. vim.inspect({ workspace, dirs, standalone, vim.api.nvim_buf_get_name(0), vim.bo.buftype })
)

for _, name in ipairs({ "neotest-vitest", "neotest-jest", "neotest-python", "neotest-go" }) do
    package.preload[name] = function()
        return function(opts)
            return { name = name, options = opts }
        end
    end
end
local test_options = dofile("lua/plugins/testing.lua")[1].opts()
local jest = test_options.adapters[2].options
assert(jest.cwd(test_file) == package_dir, "Jest cwd followed current buffer")
assert(jest.jestConfigFile(test_file) == root .. "/jest.config.mjs", "inherited Jest config not found")
assert(jest.jestConfigFile(standalone .. "/index.ts") == nil, "invented Jest config path")
assert(test_options.discovery.concurrent == 1, "unbounded test discovery")
assert(not test_options.discovery.filter_dir("node_modules"), "dependency scan allowed")
assert(test_options.discovery.filter_dir("src"), "source scan blocked")
print("PASS workspace search, file-relative Jest configuration, discovery limits")

local lsp = dofile("lua/plugins/lsp.lua")
local keys = lsp[1].opts.servers["*"].keys
local seen = {}
for _, key in ipairs(keys) do
    local identity = key[1] .. vim.inspect(key.mode or "n")
    assert(not seen[identity], "duplicate LSP mapping: " .. key[1])
    seen[identity] = true
end
assert(not lsp[2].keys, "global LSP mappings still shadow buffer mappings")
local languages = dofile("lua/plugins/completion.lua")[1].opts.servers.vtsls.settings
assert(languages.typescript ~= languages.javascript, "shared mutable language settings")
assert(languages.typescript.suggest ~= languages.javascript.suggest, "shared mutable completion settings")
assert(languages.javascript.tsserver == nil, "invalid JavaScript tsserver option")
local formatters = dofile("lua/plugins/formatting.lua")[1].opts.formatters
assert(formatters.shfmt == nil and formatters.stylua == nil, "project formatter settings overridden")
assert(formatters["clang-format"].prepend_args[1] == "--style=file", "clang-format ignores project style")
print("PASS LSP mapping ownership, independent language settings, formatter configuration")
local noice
for _, spec in ipairs(dofile("lua/plugins/completion.lua")) do
    if spec[1] == "folke/noice.nvim" then
        noice = spec.opts
    end
end
assert(noice and noice.lsp.signature.auto_open.enabled == false, "duplicate automatic signature provider")

-- Command terminals are isolated by project and dispose finished buffers on rerun.
local created, disposed = {}, 0
package.preload["toggleterm.terminal"] = function()
    return {
        Terminal = {
            new = function(_, opts)
                local term = { opts = opts, toggles = 0 }
                function term:toggle()
                    self.toggles = self.toggles + 1
                end
                function term:shutdown()
                    disposed = disposed + 1
                end
                created[#created + 1] = term
                return term
            end,
        },
    }
end
local terminal_root = root
_G.get_project_root = function()
    return terminal_root
end
local terminals = require("config.terminals")
terminals.toggle("build")
terminals.toggle("build")
assert(#created == 1 and created[1].toggles == 2, "running terminal was duplicated")
assert(created[1].opts.hidden == true, "command job leaked into generic terminal toggles")
terminal_root = standalone
terminals.toggle("build")
assert(#created == 2, "terminal reused across projects")
created[1].opts.on_exit()
terminal_root = root
terminals.toggle("build")
assert(#created == 3 and disposed == 1, "finished terminal buffer leaked")
-- A late callback from the disposed job must not mark its replacement exited.
created[1].opts.on_exit()
terminals.toggle("build")
assert(#created == 3 and disposed == 1, "stale exit callback discarded a new terminal")
print("PASS single signature provider and command-terminal lifecycle")

print("ALL LIGHTWEIGHT CONFIG CHECKS PASSED")
vim.cmd("qa!")
