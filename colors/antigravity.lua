-- Antigravity Colorscheme
-- A premium, developer-focused low-fatigue dark theme
-- Designed specifically to minimize eye strain and optimize readability over long sessions

local colors = {
  bg = "#0f1115",              -- Warm dark charcoal (extremely soft desaturated base, zero glare)
  bg_nc = "#0b0c0e",           -- Non-current window background (subtly darker for focus)
  bg_line = "#171a21",         -- Low-contrast soft cursor line
  bg_visual = "#1e2635",       -- Muted slate-indigo visual selection
  bg_search = "#273447",       -- Soft slate-blue search highlight
  bg_highlight = "#1a1d24",    -- Soft general highlight background
  bg_float = "#13161c",        -- Deeper dark charcoal for floating windows (creates depth)
  border = "#262c36",          -- Soft, low-contrast slate border
  gutter = "#0f1115",          -- Matching gutter for seamless interface

  fg = "#c5cbd3",              -- Muted off-white/platinum (highly readable, avoids harsh pure white)
  fg_muted = "#7d8a9a",        -- Soft slate grey for secondary text
  fg_dark = "#556272",         -- Warm slate-grey (ideal for comments, very easy on the eyes)

  -- Syntax Colors (desaturated, warm, pastel, low blue-light impact)
  purple = "#b392f0",          -- Muted lavender (keywords, control flow)
  cyan = "#6ba6e9",            -- Steel blue (functions, methods)
  green = "#8cb47a",           -- Sage/olive green (strings, very calming)
  yellow = "#ecd185",          -- Muted warm gold (classes, structures)
  orange = "#e09363",          -- Muted terracotta/amber (numbers, booleans)
  red = "#e06c75",             -- Soft pastel red (errors, HTML/XML tags)
  blue = "#82a1f1",            -- Soft desaturated blue (variables, identifiers)
  teal = "#5fb3b3",            -- Muted seafoam teal (types, builtins)
  magenta = "#cca1c8",         -- Muted pastel magenta (regex, special characters)
}

local hl = {}

-- Editor Core UI (Ergonomic Contrast)
hl.Normal = { fg = colors.fg, bg = colors.bg }
hl.NormalNC = { fg = colors.fg, bg = colors.bg_nc }
hl.Cursor = { reverse = true }
hl.CursorLine = { bg = colors.bg_line }
hl.CursorLineNr = { fg = colors.yellow, bold = true }
hl.LineNr = { fg = colors.fg_dark }
hl.Visual = { bg = colors.bg_visual }
hl.Search = { bg = colors.bg_search, bold = true }
hl.IncSearch = { bg = colors.bg_search, reverse = true, bold = true }
hl.VertSplit = { fg = colors.border }
hl.WinSeparator = { fg = colors.border }
hl.ColorColumn = { bg = colors.bg_nc }
hl.SignColumn = { bg = colors.bg }
hl.Folded = { fg = colors.fg_muted, bg = colors.bg_nc }
hl.FoldColumn = { fg = colors.fg_muted, bg = colors.bg }
hl.Directory = { fg = colors.blue, bold = true }
hl.Title = { fg = colors.yellow, bold = true }

-- Floating Windows & Completion Menu (Structured Depth)
hl.NormalFloat = { fg = colors.fg, bg = colors.bg_float }
hl.FloatBorder = { fg = colors.border, bg = colors.bg_float }
hl.Pmenu = { fg = colors.fg, bg = colors.bg_float }
hl.PmenuSel = { fg = colors.fg, bg = colors.bg_visual, bold = true }
hl.PmenuSbar = { bg = colors.bg_nc }
hl.PmenuThumb = { bg = colors.border }
hl.WildMenu = { fg = colors.fg, bg = colors.bg_visual }

-- Statusline & Tabline (Minimal Visual Noise)
hl.StatusLine = { fg = colors.fg, bg = colors.bg_nc }
hl.StatusLineNC = { fg = colors.fg_muted, bg = colors.bg_nc }
hl.TabLine = { fg = colors.fg_muted, bg = colors.bg_nc }
hl.TabLineSel = { fg = colors.fg, bg = colors.bg }
hl.TabLineFill = { bg = colors.bg_nc }

-- Standard Syntax Highlighting (Calm Contrast)
hl.Comment = { fg = colors.fg_dark }
hl.Constant = { fg = colors.orange }
hl.String = { fg = colors.green }
hl.Character = { fg = colors.green }
hl.Number = { fg = colors.orange }
hl.Boolean = { fg = colors.orange }
hl.Float = { fg = colors.orange }
hl.Identifier = { fg = colors.blue }
hl.Function = { fg = colors.cyan }
hl.Statement = { fg = colors.purple }
hl.Conditional = { fg = colors.purple }
hl.Repeat = { fg = colors.purple }
hl.Label = { fg = colors.purple }
hl.Operator = { fg = colors.magenta }
hl.Keyword = { fg = colors.purple }
hl.Exception = { fg = colors.purple }
hl.PreProc = { fg = colors.purple }
hl.Include = { fg = colors.purple }
hl.Define = { fg = colors.purple }
hl.Macro = { fg = colors.purple }
hl.PreCondit = { fg = colors.purple }
hl.Type = { fg = colors.teal }
hl.StorageClass = { fg = colors.purple }
hl.Structure = { fg = colors.teal }
hl.Typedef = { fg = colors.teal }
hl.Special = { fg = colors.yellow }
hl.SpecialChar = { fg = colors.orange }
hl.Tag = { fg = colors.red }
hl.Delimiter = { fg = colors.fg_muted }
hl.SpecialComment = { fg = colors.fg_muted }
hl.Debug = { fg = colors.red }
hl.Underlined = { underline = true }
hl.Ignore = { fg = colors.fg_dark }
hl.Error = { fg = colors.red, bold = true }
hl.Todo = { fg = colors.yellow, bold = true }

-- Treesitter Highlights
hl["@variable"] = { fg = colors.fg }
hl["@variable.builtin"] = { fg = colors.teal }
hl["@variable.parameter"] = { fg = colors.fg }
hl["@member"] = { fg = colors.fg }
hl["@field"] = { fg = colors.fg }
hl["@property"] = { fg = colors.fg }
hl["@constructor"] = { fg = colors.teal }
hl["@keyword"] = { fg = colors.purple }
hl["@keyword.function"] = { fg = colors.purple }
hl["@keyword.operator"] = { fg = colors.magenta }
hl["@keyword.return"] = { fg = colors.purple }
hl["@function"] = { fg = colors.cyan }
hl["@function.builtin"] = { fg = colors.cyan }
hl["@function.method"] = { fg = colors.cyan }
hl["@string"] = { fg = colors.green }
hl["@number"] = { fg = colors.orange }
hl["@boolean"] = { fg = colors.orange }
hl["@type"] = { fg = colors.teal }
hl["@type.builtin"] = { fg = colors.teal }
hl["@constant"] = { fg = colors.yellow }
hl["@constant.builtin"] = { fg = colors.orange }
hl["@operator"] = { fg = colors.magenta }
hl["@punctuation.delimiter"] = { fg = colors.fg_muted }
hl["@punctuation.bracket"] = { fg = colors.fg_muted }
hl["@tag"] = { fg = colors.red }
hl["@tag.attribute"] = { fg = colors.yellow }
hl["@tag.delimiter"] = { fg = colors.fg_muted }
hl["@label"] = { fg = colors.purple }

-- Diagnostics (Soft alert colors)
hl.DiagnosticError = { fg = colors.red }
hl.DiagnosticWarn = { fg = colors.orange }
hl.DiagnosticInfo = { fg = colors.cyan }
hl.DiagnosticHint = { fg = colors.teal }

hl.DiagnosticUnderlineError = { underline = true, sp = colors.red }
hl.DiagnosticUnderlineWarn = { underline = true, sp = colors.orange }
hl.DiagnosticUnderlineInfo = { underline = true, sp = colors.cyan }
hl.DiagnosticUnderlineHint = { underline = true, sp = colors.teal }

-- Git Diffs (Soft, low-fatigue highlights)
hl.DiffAdd = { fg = colors.green, bg = "#17271b" }
hl.DiffChange = { fg = colors.blue, bg = "#172233" }
hl.DiffDelete = { fg = colors.red, bg = "#2f171c" }
hl.DiffText = { fg = colors.fg, bg = "#25374e" }

-- Neo-tree
hl.NeoTreeDirectoryName = { fg = colors.fg_muted }
hl.NeoTreeDirectoryIcon = { fg = colors.blue }
hl.NeoTreeRootName = { fg = colors.yellow, bold = true }
hl.NeoTreeFileName = { fg = colors.fg }
hl.NeoTreeSymbolicLinkTarget = { fg = colors.teal }

-- Telescope
hl.TelescopeBorder = { fg = colors.border, bg = colors.bg_float }
hl.TelescopeNormal = { fg = colors.fg, bg = colors.bg_float }
hl.TelescopeSelection = { fg = colors.fg, bg = colors.bg_visual, bold = true }

-- Blink.cmp
hl.BlinkCmpMenu = { fg = colors.fg, bg = colors.bg_float }
hl.BlinkCmpMenuBorder = { fg = colors.border, bg = colors.bg_float }
hl.BlinkCmpDoc = { fg = colors.fg, bg = colors.bg_float }
hl.BlinkCmpDocBorder = { fg = colors.border, bg = colors.bg_float }
hl.BlinkCmpSignatureHelp = { fg = colors.fg, bg = colors.bg_float }
hl.BlinkCmpSignatureHelpBorder = { fg = colors.border, bg = colors.bg_float }

-- Delimiters & Invisible characters (Subdued to prevent distraction)
hl.NonText = { fg = "#202631" }
hl.Whitespace = { fg = "#202631" }
hl.SpecialKey = { fg = "#202631" }

-- Apply highlights
vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "antigravity"

for group, settings in pairs(hl) do
  vim.api.nvim_set_hl(0, group, settings)
end
