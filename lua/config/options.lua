-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Use LSP root first (respects tsconfig.json / package.json per-package),
-- then monorepo markers, then CWD as fallback
vim.g.root_spec = { "lsp", { ".git", "turbo.json" }, "cwd" }

-- Set cursor to block in all modes (including insert mode)
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"

-- Auto-save related options
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.updatetime = 200

-- Editing ergonomics
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.scrolloff = 6
vim.opt.sidescrolloff = 6
vim.opt.confirm = true

-- Search defaults
vim.opt.ignorecase = true
vim.opt.smartcase = true


-- Word wrap defaults
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "
