local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({"git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath})
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({{"Failed to clone lazy.nvim:\n", "ErrorMsg"}, {out, "WarningMsg"},
                           {"\nPress any key to exit..."}}, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

-- Defensive guard: Prevent Mason's "Package is already installing" crash/race condition
local ok_pkg, Package = pcall(require, "mason-core.package")
if ok_pkg and Package and type(Package.install) == "function" then
    local orig_install = Package.install
    Package.install = function(self, opts, callback)
        if self:is_installing() then
            if callback then
                self:once("closed", vim.schedule_wrap(function()
                    callback(self:is_installed())
                end))
            end
            return self.handle
        end
        return orig_install(self, opts, callback)
    end
end

-- Defensive guard: Ensure treesitter cli callback handles installing/installed states without throwing or hanging
local ok_ts, ts_util = pcall(require, "lazyvim.util.treesitter")
if ok_ts and ts_util then
    ts_util.ensure_treesitter_cli = function(cb)
        if vim.fn.executable("tree-sitter") == 1 then
            return cb(true)
        end
        if not pcall(require, "mason") then
            return cb(false, "`mason.nvim` is disabled in your config, so we cannot install it automatically.")
        end
        local mr = require("mason-registry")
        mr.refresh(function()
            local p = mr.get_package("tree-sitter-cli")
            if p:is_installed() then
                return cb(true)
            end
            if p:is_installing() then
                p:once("closed", vim.schedule_wrap(function()
                    cb(p:is_installed())
                end))
                return
            end
            p:install(
                nil,
                vim.schedule_wrap(function(success)
                    cb(success, success and nil or "Failed to install `tree-sitter-cli` with `mason.nvim`.")
                end)
            )
        end)
    end
end

require("lazy").setup({
    spec = { -- add LazyVim and import its plugins
    {
        "LazyVim/LazyVim",
        import = "lazyvim.plugins"
    },
    { import = "lazyvim.plugins.extras.editor.neo-tree" },
    -- import/override with your plugins
    {
        import = "plugins"
    }},
    defaults = {
        -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
        -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
        lazy = false,
        -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
        -- have outdated releases, which may break your Neovim install.
        version = false -- always use the latest git commit
        -- version = "*", -- try installing the latest stable version for plugins that support semver
    },
    install = {
        colorscheme = {"prodev", "habamax"}
    },
    rocks = {
        enabled = false
    },
    checker = {
        enabled = false, -- disable background update checks to prevent network polling and CPU lag
    },
    performance = {
        rtp = {
            -- disable some rtp plugins
            disabled_plugins = {"gzip", "matchit", "matchparen", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin"}
        }
    }
})
