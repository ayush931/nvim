-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Disable unused providers to avoid healthcheck warnings & speed startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Use LSP root first (respects tsconfig.json / package.json per-package),
-- then monorepo markers, then CWD as fallback
vim.g.root_spec = { "lsp", { ".git", "turbo.json" }, "cwd" }

-- Set cursor to block in all modes (including insert mode)
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:block,r-cr-o:block"
vim.opt.guifont = "Fira Code:h10.5"





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

-- Ergonomics
if vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
  local paste_cmd = "wl-paste --no-newline --type text/plain"
  local paste_primary_cmd = "wl-paste --primary --no-newline --type text/plain"
  if vim.fn.executable("timeout") == 1 then
    paste_cmd = "timeout 0.5 " .. paste_cmd
    paste_primary_cmd = "timeout 0.5 " .. paste_primary_cmd
  end

  vim.g.clipboard = {
    name = "wl-clipboard",
    copy = {
      ["+"] = "wl-copy --type text/plain",
      ["*"] = "wl-copy --primary --type text/plain",
    },
    paste = {
      ["+"] = paste_cmd,
      ["*"] = paste_primary_cmd,
    },
    cache_enabled = 1,
  }
end

vim.opt.clipboard = "unnamedplus"
vim.opt.cursorline = true

-- Word wrap defaults
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

-- Do not automatically insert comment leader on next line when pressing Enter or o/O
vim.opt.formatoptions:remove({ "c", "r", "o" })

-- Ensure selection does not switch to select/visual mode on completion
vim.opt.selectmode = ""

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.showtabline = 0

-- Auto-create missing parent directories when saving a file
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function(event)
        if not event.file or event.file == "" or event.file:match("^%w%w+:[\\/][\\/]") then
            return
        end
        local dir = vim.fn.fnamemodify(event.file, ":p:h")
        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, "p")
        end
    end,
})



