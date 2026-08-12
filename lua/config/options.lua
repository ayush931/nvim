-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Find and dynamically resolve the project root directory of the active file or workspace
_G.get_project_root = function()
  local current = vim.api.nvim_buf_get_name(0)
  if current == "" or vim.bo.buftype ~= "" then
    current = vim.uv.cwd()
  end
  local root = vim.fs.root(current, { ".git", "turbo.json", "package.json", "Makefile", "Cargo.toml", "go.mod" })
  return root or vim.uv.cwd()
end


-- Ensure user local bin and bun bin directories are in PATH for LSP language servers (vtsls, tailwind, etc.)
local home = os.getenv("HOME") or ""
if home ~= "" then
  local extra_paths = {
    home .. "/.local/bin",
    home .. "/.bun/bin",
    home .. "/.cargo/bin",
  }
  local current_path = os.getenv("PATH") or ""
  for _, p in ipairs(extra_paths) do
    if vim.fn.isdirectory(p) == 1 and not current_path:find(p, 1, true) then
      current_path = p .. ":" .. current_path
    end
  end
  vim.env.PATH = current_path
end

-- Disable unused providers to avoid healthcheck warnings & speed startup
vim.g.loaded_python3_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

-- Use Git/project root first, then monorepo markers, LSP, then CWD as fallback
vim.g.root_spec = { ".git", "turbo.json", "package.json", "lsp", "cwd" }

-- GUI Font & Zoom settings
local default_font_size = 7
vim.opt.guifont = "Fira Code:h" .. default_font_size

-- Dynamic font zoom controls for GUIs (Neovide, Nvim-qt, etc.)
local current_font_size = default_font_size
local function set_font_size(size)
  current_font_size = math.max(4, math.min(30, size))
  vim.opt.guifont = "Fira Code:h" .. current_font_size
  if vim.g.neovide then
    vim.g.neovide_scale_factor = current_font_size / 8.0
  end
end

vim.keymap.set({ "n", "v", "i" }, "<C-->", function() set_font_size(current_font_size - 1) end, { desc = "Zoom Out (Reduce Font Size)" })
vim.keymap.set({ "n", "v", "i" }, "<C-=>", function() set_font_size(current_font_size + 1) end, { desc = "Zoom In (Increase Font Size)" })
vim.keymap.set({ "n", "v", "i" }, "<C-0>", function() set_font_size(default_font_size) end, { desc = "Reset Font Size" })

-- Cursor shaping: block in normal/visual mode, thin vertical line (ver10) in insert mode
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver10,r-cr:hor20,o:hor50"

-- Auto-save related options
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.updatetime = 200

-- Editing ergonomics
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.timeoutlen = 800
vim.opt.ttimeoutlen = 10
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

vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.showbreak = "↳ "

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
