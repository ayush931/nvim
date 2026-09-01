-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- Find and dynamically resolve the project root directory of the active file or workspace
_G.get_project_root = function()
    local current = vim.api.nvim_buf_get_name(0)
    local cwd = (vim.uv or vim.loop).cwd() or vim.fn.getcwd()
    if current == "" or vim.bo.buftype ~= "" then
        return cwd
    end
    local root = vim.fs.root(current, {".git", "turbo.json", "package.json", "Makefile", "Cargo.toml", "go.mod"})
    return root or cwd
end

-- Ensure user local bin and bun bin directories are in PATH for LSP language servers (vtsls, tailwind, etc.)
local home = os.getenv("HOME") or ""
if home ~= "" then
    local uv = vim.uv or vim.loop
    local extra_paths = {home .. "/.local/bin", home .. "/.bun/bin", home .. "/.cargo/bin"}
    local current_path = os.getenv("PATH") or ""
    for _, p in ipairs(extra_paths) do
        if uv.fs_stat(p) and not current_path:find(p, 1, true) then
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
vim.g.root_spec = {".git", "turbo.json", "package.json", "lsp", "cwd"}

-- GUI Font & Zoom settings (Fira Code with ligatures)
local default_font_size = 11
vim.opt.guifont = "Fira Code:h" .. default_font_size

-- Dynamic font zoom controls for GUIs (Neovide, Nvim-qt, etc.)
local current_font_size = default_font_size
local function set_font_size(size)
    current_font_size = math.max(6, math.min(30, size))
    vim.opt.guifont = "Fira Code:h" .. current_font_size
    if vim.g.neovide then
        vim.g.neovide_scale_factor = current_font_size / 12.0
    end
end

vim.keymap.set({"n", "v", "i"}, "<C-->", function()
    set_font_size(current_font_size - 1)
end, {
    desc = "Zoom Out (Reduce Font Size)"
})
vim.keymap.set({"n", "v", "i"}, "<C-=>", function()
    set_font_size(current_font_size + 1)
end, {
    desc = "Zoom In (Increase Font Size)"
})
vim.keymap.set({"n", "v", "i"}, "<C-0>", function()
    set_font_size(default_font_size)
end, {
    desc = "Reset Font Size"
})

-- Neovide-specific clarity enhancements
if vim.g.neovide then
    vim.g.neovide_text_gamma = 0.0
    vim.g.neovide_text_contrast = 0.1
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_blur_amount_x = 3
    vim.g.neovide_floating_blur_amount_y = 3
end

-- Cursor shaping: block in normal/visual/command, ultra-thin vertical line (1%) in insert mode
vim.opt.guicursor = "n-v-c-sm:block-Cursor/lCursor,i-ci-ve:ver1-Cursor/lCursor,r-cr:hor20-rCursor,o:hor50-Cursor"

-- Ensure cursor highlight groups are pure white across all modes
local function set_cursor_highlights()
    local c_white = "#FFFFFF"
    local c_bg = "#1E2024"
    vim.api.nvim_set_hl(0, "Cursor", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "lCursor", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "CursorIM", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "TermCursor", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "TermCursorNC", { fg = "#828C9E", bg = "#353A45", bold = true })
    vim.api.nvim_set_hl(0, "vCursor", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "iCursor", { fg = c_bg, bg = c_white, bold = true })
    vim.api.nvim_set_hl(0, "rCursor", { fg = c_bg, bg = c_white, bold = true })
end
set_cursor_highlights()
vim.api.nvim_create_autocmd({"ColorScheme", "VimEnter"}, {
    callback = set_cursor_highlights,
})

-- Auto-save related options
vim.opt.autowrite = true
vim.opt.autowriteall = false
vim.opt.updatetime = 300

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

-- Ergonomics & Wayland clipboard detection (only if WAYLAND_DISPLAY is active to avoid hangs/lag)
if vim.env.WAYLAND_DISPLAY and vim.fn.executable("wl-copy") == 1 and vim.fn.executable("wl-paste") == 1 then
    local paste_cmd = "wl-paste --no-newline --type text/plain"
    local paste_primary_cmd = "wl-paste --primary --no-newline --type text/plain"
    if vim.fn.executable("timeout") == 1 then
        paste_cmd = "timeout 0.05 " .. paste_cmd
        paste_primary_cmd = "timeout 0.05 " .. paste_primary_cmd
    end

    vim.g.clipboard = {
        name = "wl-clipboard",
        copy = {
            ["+"] = "wl-copy --type text/plain",
            ["*"] = "wl-copy --primary --type text/plain"
        },
        paste = {
            ["+"] = paste_cmd,
            ["*"] = paste_primary_cmd
        },
        cache_enabled = 1
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
        local uv = vim.uv or vim.loop
        if not uv.fs_stat(dir) then
            vim.fn.mkdir(dir, "p")
        end
    end
})
