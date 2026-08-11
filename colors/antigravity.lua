-- Antigravity Colorscheme
-- A premium, developer-focused low-fatigue dark theme
-- Designed to minimize eye strain while feeling vibrant, layered, and polished

local c = {
  -- ── Base surfaces (neutral grey gradient, 5 tiers of depth) ──
  bg_deep    = "#111111",        -- Deepest layer: inactive panes, gutters
  bg         = "#181818",        -- Primary editing surface
  bg_raised  = "#212121",        -- Cursorline, subtle lifts
  bg_surface = "#262626",        -- Floats, popups, sidebars
  bg_overlay = "#2e2e2e",        -- Menus, selections, visual
  bg_accent  = "#383838",        -- Active selections, search matches

  -- ── Borders & chrome ──
  border       = "#353535",      -- Default separator
  border_focus = "#505050",      -- Focused / active borders

  -- ── Foreground scale ──
  fg         = "#d0d5dd",        -- Primary text (warm platinum)
  fg_soft    = "#a3acba",        -- Secondary text, parameters
  fg_muted   = "#6e7a8c",        -- Tertiary: line numbers, inactive tabs
  fg_faint   = "#444e5e",        -- Comments, invisible chars
  fg_ghost   = "#2a2a2a",        -- Indent guides, trailing whitespace

  -- ── Syntax palette (rich but never neon) ──
  rose       = "#e8737d",        -- Errors, HTML tags, deletions
  coral      = "#e8956a",        -- Numbers, booleans, constants
  amber      = "#e4c36a",        -- Warnings, classes, decorators
  sage       = "#8ec87a",        -- Strings (warm, calming green)
  jade       = "#5cc5a0",        -- Types, builtins (tropical green)
  sky        = "#6db3e8",        -- Functions, methods
  steel      = "#8ea6f0",        -- Variables, identifiers
  lilac      = "#c49be0",        -- Keywords, control flow
  mauve      = "#d6a0c8",        -- Regex, special chars, operators

  -- ── Diagnostic tints (for underline + subtle background) ──
  diag_err_bg  = "#1f1114",
  diag_warn_bg = "#1f1a10",
  diag_info_bg = "#0f1720",
  diag_hint_bg = "#0f1a18",

  -- ── Diff tints ──
  diff_add_bg    = "#132618",
  diff_change_bg = "#131d2e",
  diff_delete_bg = "#261218",
  diff_text_bg   = "#1e3050",

  -- ── Git signs ──
  git_add    = "#6db87a",
  git_change = "#6ba8d8",
  git_delete = "#d06870",
}

-- ─────────────────────────────────────────────────────────
-- Highlight definitions
-- ─────────────────────────────────────────────────────────
local hl = {}

-- ── Editor Core ──
hl.Normal       = { fg = c.fg, bg = c.bg }
hl.NormalNC     = { fg = c.fg_soft, bg = c.bg_deep }
hl.NormalFloat  = { fg = c.fg, bg = c.bg_surface }
hl.FloatBorder  = { fg = c.border_focus, bg = c.bg_surface }
hl.FloatTitle   = { fg = c.amber, bg = c.bg_surface }

hl.Cursor       = { reverse = true }
hl.lCursor      = { link = "Cursor" }
hl.CursorIM     = { link = "Cursor" }
hl.TermCursor   = { reverse = true }
hl.TermCursorNC = { fg = c.fg_muted }
hl.CursorLine   = {}
hl.CursorColumn = { bg = c.bg_raised }
hl.CursorLineNr = { fg = c.amber }
hl.LineNr       = { fg = c.fg_faint }
hl.LineNrAbove  = { fg = c.fg_faint }
hl.LineNrBelow  = { fg = c.fg_faint }

hl.Visual       = { bg = c.bg_overlay }
hl.VisualNOS    = { bg = c.bg_overlay }
hl.Search       = { fg = c.fg, bg = c.bg_accent }
hl.IncSearch    = { fg = c.bg, bg = c.amber }
hl.CurSearch    = { fg = c.bg, bg = c.coral }
hl.Substitute   = { fg = c.bg, bg = c.rose }

hl.MatchParen   = { fg = c.amber, underline = true }
hl.ModeMsg      = { fg = c.fg }
hl.MsgArea      = { fg = c.fg_soft }
hl.MoreMsg      = { fg = c.jade }
hl.Question     = { fg = c.sky }
hl.WarningMsg   = { fg = c.amber }
hl.ErrorMsg     = { fg = c.rose }

hl.VertSplit    = { fg = c.border }
hl.WinSeparator = { fg = c.border }
hl.ColorColumn  = { bg = c.bg_deep }
hl.Conceal      = { fg = c.fg_muted }
hl.EndOfBuffer  = { fg = c.fg_ghost }
hl.SignColumn    = { bg = c.bg }

hl.Folded       = { fg = c.fg_muted, bg = c.bg_raised }
hl.FoldColumn   = { fg = c.fg_faint, bg = c.bg }
hl.Directory    = { fg = c.sky }
hl.Title        = { fg = c.amber }
hl.SpecialKey   = { fg = c.fg_ghost }
hl.NonText      = { fg = c.fg_ghost }
hl.Whitespace   = { fg = c.fg_ghost }
hl.WinBar       = { fg = c.fg_soft, bg = c.bg }
hl.WinBarNC     = { fg = c.fg_muted, bg = c.bg_deep }

-- ── Completion Menu (Pmenu) ──
hl.Pmenu        = { fg = c.fg, bg = c.bg_surface }
hl.PmenuSel     = { fg = c.fg, bg = c.bg_overlay }
hl.PmenuKind    = { fg = c.lilac, bg = c.bg_surface }
hl.PmenuKindSel = { fg = c.lilac, bg = c.bg_overlay }
hl.PmenuExtra   = { fg = c.fg_muted, bg = c.bg_surface }
hl.PmenuExtraSel = { fg = c.fg_soft, bg = c.bg_overlay }
hl.PmenuSbar    = { bg = c.bg_deep }
hl.PmenuThumb   = { bg = c.border }
hl.WildMenu     = { fg = c.fg, bg = c.bg_overlay }

-- ── Statusline & Tabline ──
hl.StatusLine   = { fg = c.fg_soft, bg = c.bg_deep }
hl.StatusLineNC = { fg = c.fg_faint, bg = c.bg_deep }
hl.TabLine      = { fg = c.fg_muted, bg = c.bg_deep }
hl.TabLineSel   = { fg = c.fg, bg = c.bg }
hl.TabLineFill  = { bg = c.bg_deep }

-- ═══════════════════════════════════════════════════════════
-- SYNTAX  (vim builtin groups)
-- ═══════════════════════════════════════════════════════════

hl.Comment      = { fg = c.fg_faint }
hl.Constant     = { fg = c.coral }
hl.String       = { fg = c.sage }
hl.Character    = { fg = c.sage }
hl.Number       = { fg = c.coral }
hl.Boolean      = { fg = c.coral }
hl.Float        = { fg = c.coral }

hl.Identifier   = { fg = c.fg }
hl.Function     = { fg = c.sky }

hl.Statement    = { fg = c.lilac }
hl.Conditional  = { fg = c.lilac }
hl.Repeat       = { fg = c.lilac }
hl.Label        = { fg = c.lilac }
hl.Operator     = { fg = c.mauve }
hl.Keyword      = { fg = c.lilac }
hl.Exception    = { fg = c.lilac }

hl.PreProc      = { fg = c.lilac }
hl.Include      = { fg = c.lilac }
hl.Define       = { fg = c.lilac }
hl.Macro        = { fg = c.coral }
hl.PreCondit    = { fg = c.lilac }

hl.Type         = { fg = c.jade }
hl.StorageClass = { fg = c.lilac }
hl.Structure    = { fg = c.jade }
hl.Typedef      = { fg = c.jade }

hl.Special      = { fg = c.amber }
hl.SpecialChar  = { fg = c.coral }
hl.Tag          = { fg = c.rose }
hl.Delimiter    = { fg = c.fg_muted }
hl.SpecialComment = { fg = c.fg_muted }
hl.Debug        = { fg = c.rose }

hl.Underlined   = { fg = c.sky, underline = true }
hl.Ignore       = { fg = c.fg_faint }
hl.Error        = { fg = c.rose }
hl.Todo         = { fg = c.amber, bg = c.bg_raised }

-- ═══════════════════════════════════════════════════════════
-- TREESITTER
-- ═══════════════════════════════════════════════════════════

-- Identifiers
hl["@variable"]                = { fg = c.fg }
hl["@variable.builtin"]        = { fg = c.jade }
hl["@variable.parameter"]      = { fg = c.fg_soft }
hl["@variable.parameter.builtin"] = { fg = c.fg_soft }
hl["@variable.member"]         = { fg = c.fg }

-- Constants
hl["@constant"]                = { fg = c.amber }
hl["@constant.builtin"]        = { fg = c.coral }
hl["@constant.macro"]          = { fg = c.coral }

-- Modules / Namespaces
hl["@module"]                  = { fg = c.fg_soft }
hl["@module.builtin"]          = { fg = c.jade }

-- Strings
hl["@string"]                  = { fg = c.sage }
hl["@string.documentation"]    = { fg = c.sage }
hl["@string.regex"]            = { fg = c.mauve }
hl["@string.escape"]           = { fg = c.coral }
hl["@string.special"]          = { fg = c.mauve }
hl["@string.special.symbol"]   = { fg = c.amber }
hl["@string.special.url"]      = { fg = c.sky, underline = true }
hl["@string.special.path"]     = { fg = c.sky }

-- Numbers & Booleans
hl["@number"]                  = { fg = c.coral }
hl["@number.float"]            = { fg = c.coral }
hl["@boolean"]                 = { fg = c.coral }
hl["@character"]               = { fg = c.sage }
hl["@character.special"]       = { fg = c.coral }

-- Types
hl["@type"]                    = { fg = c.jade }
hl["@type.builtin"]            = { fg = c.jade }
hl["@type.definition"]         = { fg = c.jade }
hl["@type.qualifier"]          = { fg = c.lilac }
hl["@attribute"]               = { fg = c.amber }
hl["@attribute.builtin"]       = { fg = c.amber }

-- Functions
hl["@function"]                = { fg = c.sky }
hl["@function.builtin"]        = { fg = c.sky }
hl["@function.call"]           = { fg = c.sky }
hl["@function.macro"]          = { fg = c.coral }
hl["@function.method"]         = { fg = c.sky }
hl["@function.method.call"]    = { fg = c.sky }
hl["@constructor"]             = { fg = c.jade }

-- Keywords
hl["@keyword"]                 = { fg = c.lilac }
hl["@keyword.coroutine"]       = { fg = c.lilac }
hl["@keyword.function"]        = { fg = c.lilac }
hl["@keyword.operator"]        = { fg = c.mauve }
hl["@keyword.import"]          = { fg = c.lilac }
hl["@keyword.type"]            = { fg = c.lilac }
hl["@keyword.modifier"]        = { fg = c.lilac }
hl["@keyword.repeat"]          = { fg = c.lilac }
hl["@keyword.return"]          = { fg = c.lilac }
hl["@keyword.debug"]           = { fg = c.rose }
hl["@keyword.exception"]       = { fg = c.lilac }
hl["@keyword.conditional"]     = { fg = c.lilac }
hl["@keyword.conditional.ternary"] = { fg = c.mauve }
hl["@keyword.directive"]       = { fg = c.lilac }
hl["@keyword.directive.define"] = { fg = c.lilac }

-- Operators & Punctuation
hl["@operator"]                = { fg = c.mauve }
hl["@punctuation.delimiter"]   = { fg = c.fg_muted }
hl["@punctuation.bracket"]     = { fg = c.fg_soft }
hl["@punctuation.special"]     = { fg = c.mauve }

-- Comments
hl["@comment"]                 = { fg = c.fg_faint }
hl["@comment.documentation"]   = { fg = c.fg_muted }
hl["@comment.error"]           = { fg = c.rose }
hl["@comment.warning"]         = { fg = c.amber }
hl["@comment.todo"]            = { fg = c.amber }
hl["@comment.note"]            = { fg = c.sky }

-- Markup (markdown, etc.)


hl["@markup.strikethrough"]    = { strikethrough = true }
hl["@markup.underline"]        = { underline = true }
hl["@markup.heading"]          = { fg = c.amber }
hl["@markup.heading.1"]        = { fg = c.amber }
hl["@markup.heading.2"]        = { fg = c.sky }
hl["@markup.heading.3"]        = { fg = c.jade }
hl["@markup.heading.4"]        = { fg = c.lilac }
hl["@markup.heading.5"]        = { fg = c.mauve }
hl["@markup.heading.6"]        = { fg = c.fg_soft }
hl["@markup.quote"]            = { fg = c.fg_muted }
hl["@markup.math"]             = { fg = c.coral }
hl["@markup.link"]             = { fg = c.sky, underline = true }
hl["@markup.link.label"]       = { fg = c.sky }
hl["@markup.link.url"]         = { fg = c.fg_muted, underline = true }
hl["@markup.raw"]              = { fg = c.sage }
hl["@markup.raw.block"]        = { fg = c.fg }
hl["@markup.list"]             = { fg = c.mauve }
hl["@markup.list.checked"]     = { fg = c.jade }
hl["@markup.list.unchecked"]   = { fg = c.fg_muted }

-- Tags (HTML / JSX)
hl["@tag"]                     = { fg = c.rose }
hl["@tag.builtin"]             = { fg = c.rose }
hl["@tag.attribute"]           = { fg = c.amber }
hl["@tag.delimiter"]           = { fg = c.fg_muted }

-- Labels
hl["@label"]                   = { fg = c.lilac }

-- ═══════════════════════════════════════════════════════════
-- LSP SEMANTIC TOKENS
-- ═══════════════════════════════════════════════════════════

hl["@lsp.type.class"]          = { fg = c.jade }
hl["@lsp.type.comment"]        = { link = "@comment" }
hl["@lsp.type.decorator"]      = { fg = c.amber }
hl["@lsp.type.enum"]           = { fg = c.jade }
hl["@lsp.type.enumMember"]     = { fg = c.coral }
hl["@lsp.type.function"]       = { link = "@function" }
hl["@lsp.type.interface"]      = { fg = c.jade }
hl["@lsp.type.keyword"]        = { link = "@keyword" }
hl["@lsp.type.macro"]          = { link = "@function.macro" }
hl["@lsp.type.method"]         = { link = "@function.method" }
hl["@lsp.type.namespace"]      = { fg = c.fg_soft }
hl["@lsp.type.number"]         = { link = "@number" }
hl["@lsp.type.operator"]       = { link = "@operator" }
hl["@lsp.type.parameter"]      = { link = "@variable.parameter" }
hl["@lsp.type.property"]       = { fg = c.fg }
hl["@lsp.type.string"]         = { link = "@string" }
hl["@lsp.type.struct"]         = { fg = c.jade }
hl["@lsp.type.type"]           = { link = "@type" }
hl["@lsp.type.typeParameter"]  = { fg = c.jade }
hl["@lsp.type.variable"]       = { link = "@variable" }

hl["@lsp.mod.deprecated"]      = { strikethrough = true }


-- ═══════════════════════════════════════════════════════════
-- DIAGNOSTICS
-- ═══════════════════════════════════════════════════════════

hl.DiagnosticError = { fg = c.rose }
hl.DiagnosticWarn  = { fg = c.amber }
hl.DiagnosticInfo  = { fg = c.sky }
hl.DiagnosticHint  = { fg = c.jade }
hl.DiagnosticOk    = { fg = c.sage }

hl.DiagnosticUnderlineError = { undercurl = true, sp = c.rose }
hl.DiagnosticUnderlineWarn  = { undercurl = true, sp = c.amber }
hl.DiagnosticUnderlineInfo  = { undercurl = true, sp = c.sky }
hl.DiagnosticUnderlineHint  = { undercurl = true, sp = c.jade }
hl.DiagnosticUnderlineOk    = { undercurl = true, sp = c.sage }

hl.DiagnosticVirtualTextError = { fg = c.rose, bg = c.diag_err_bg }
hl.DiagnosticVirtualTextWarn  = { fg = c.amber, bg = c.diag_warn_bg }
hl.DiagnosticVirtualTextInfo  = { fg = c.sky, bg = c.diag_info_bg }
hl.DiagnosticVirtualTextHint  = { fg = c.jade, bg = c.diag_hint_bg }

hl.DiagnosticSignError = { fg = c.rose }
hl.DiagnosticSignWarn  = { fg = c.amber }
hl.DiagnosticSignInfo  = { fg = c.sky }
hl.DiagnosticSignHint  = { fg = c.jade }

-- ═══════════════════════════════════════════════════════════
-- GIT  (diffs, signs, blame)
-- ═══════════════════════════════════════════════════════════

hl.DiffAdd     = { bg = c.diff_add_bg }
hl.DiffChange  = { bg = c.diff_change_bg }
hl.DiffDelete  = { fg = c.rose, bg = c.diff_delete_bg }
hl.DiffText    = { bg = c.diff_text_bg }

hl.Added       = { fg = c.git_add }
hl.Changed     = { fg = c.git_change }
hl.Removed     = { fg = c.git_delete }

-- Gitsigns
hl.GitSignsAdd    = { fg = c.git_add }
hl.GitSignsChange = { fg = c.git_change }
hl.GitSignsDelete = { fg = c.git_delete }

-- ═══════════════════════════════════════════════════════════
-- PLUGIN INTEGRATIONS
-- ═══════════════════════════════════════════════════════════

-- ── Neo-tree ──
hl.NeoTreeDirectoryName  = { fg = c.fg_soft }
hl.NeoTreeDirectoryIcon  = { fg = c.sky }
hl.NeoTreeRootName       = { fg = c.amber }
hl.NeoTreeFileName       = { fg = c.fg }
hl.NeoTreeFileNameOpened = { fg = c.sky }
hl.NeoTreeGitAdded       = { fg = c.git_add }
hl.NeoTreeGitConflict    = { fg = c.rose }
hl.NeoTreeGitDeleted     = { fg = c.git_delete }
hl.NeoTreeGitModified    = { fg = c.git_change }
hl.NeoTreeGitUntracked   = { fg = c.fg_muted }
hl.NeoTreeIndentMarker   = { fg = c.fg_ghost }
hl.NeoTreeSymbolicLinkTarget = { fg = c.jade }
hl.NeoTreeNormal         = { fg = c.fg, bg = c.bg_deep }
hl.NeoTreeNormalNC       = { fg = c.fg_soft, bg = c.bg_deep }
hl.NeoTreeWinSeparator   = { fg = c.border, bg = c.bg_deep }
hl.NeoTreeCursorLine     = { bg = c.bg_raised }

-- ── Telescope ──
hl.TelescopeNormal        = { fg = c.fg, bg = c.bg_surface }
hl.TelescopeBorder        = { fg = c.border_focus, bg = c.bg_surface }
hl.TelescopeTitle         = { fg = c.amber, bg = c.bg_surface }
hl.TelescopePromptNormal  = { fg = c.fg, bg = c.bg_raised }
hl.TelescopePromptBorder  = { fg = c.border_focus, bg = c.bg_raised }
hl.TelescopePromptTitle   = { fg = c.amber, bg = c.bg_raised }
hl.TelescopePromptPrefix  = { fg = c.sky }
hl.TelescopePreviewNormal = { fg = c.fg, bg = c.bg_deep }
hl.TelescopePreviewBorder = { fg = c.border, bg = c.bg_deep }
hl.TelescopePreviewTitle  = { fg = c.amber, bg = c.bg_deep }
hl.TelescopeResultsNormal = { fg = c.fg, bg = c.bg_surface }
hl.TelescopeResultsBorder = { fg = c.border_focus, bg = c.bg_surface }
hl.TelescopeSelection     = { fg = c.fg, bg = c.bg_overlay }
hl.TelescopeSelectionCaret = { fg = c.sky }
hl.TelescopeMatching      = { fg = c.amber }

-- ── Blink.cmp ──
hl.BlinkCmpMenu           = { fg = c.fg, bg = c.bg_surface }
hl.BlinkCmpMenuBorder     = { fg = c.border_focus, bg = c.bg_surface }
hl.BlinkCmpMenuSelection  = { bg = c.bg_overlay }
hl.BlinkCmpDoc            = { fg = c.fg, bg = c.bg_surface }
hl.BlinkCmpDocBorder      = { fg = c.border_focus, bg = c.bg_surface }
hl.BlinkCmpDocSeparator   = { fg = c.border, bg = c.bg_surface }
hl.BlinkCmpSignatureHelp       = { fg = c.fg, bg = c.bg_surface }
hl.BlinkCmpSignatureHelpBorder = { fg = c.border_focus, bg = c.bg_surface }
hl.BlinkCmpLabel          = { fg = c.fg }
hl.BlinkCmpLabelMatch     = { fg = c.amber }
hl.BlinkCmpLabelDeprecated = { fg = c.fg_muted, strikethrough = true }
hl.BlinkCmpKind           = { fg = c.lilac }
hl.BlinkCmpSource         = { fg = c.fg_muted }

-- Completion item kinds
hl.BlinkCmpKindText          = { fg = c.fg_soft }
hl.BlinkCmpKindMethod        = { fg = c.sky }
hl.BlinkCmpKindFunction      = { fg = c.sky }
hl.BlinkCmpKindConstructor   = { fg = c.jade }
hl.BlinkCmpKindField         = { fg = c.fg }
hl.BlinkCmpKindVariable      = { fg = c.steel }
hl.BlinkCmpKindClass         = { fg = c.jade }
hl.BlinkCmpKindInterface     = { fg = c.jade }
hl.BlinkCmpKindModule        = { fg = c.fg_soft }
hl.BlinkCmpKindProperty      = { fg = c.fg }
hl.BlinkCmpKindUnit          = { fg = c.coral }
hl.BlinkCmpKindValue         = { fg = c.coral }
hl.BlinkCmpKindEnum          = { fg = c.jade }
hl.BlinkCmpKindKeyword       = { fg = c.lilac }
hl.BlinkCmpKindSnippet       = { fg = c.mauve }
hl.BlinkCmpKindColor         = { fg = c.amber }
hl.BlinkCmpKindFile          = { fg = c.fg }
hl.BlinkCmpKindFolder        = { fg = c.sky }
hl.BlinkCmpKindEvent         = { fg = c.amber }
hl.BlinkCmpKindOperator      = { fg = c.mauve }
hl.BlinkCmpKindTypeParameter = { fg = c.jade }

-- ── Indent Blankline ──
hl.IblIndent   = { fg = "#3a3a3a" }
hl.IblScope    = { fg = "#626262" }
hl.IblWhitespace = { fg = c.fg_ghost }

-- ── Lazy.nvim ──
hl.LazyH1       = { fg = c.bg, bg = c.amber }
hl.LazyH2       = { fg = c.amber }
hl.LazyButton   = { fg = c.fg, bg = c.bg_raised }
hl.LazyButtonActive = { fg = c.bg, bg = c.sky }
hl.LazySpecial  = { fg = c.jade }
hl.LazyComment  = { fg = c.fg_faint }

-- ── Mason ──
hl.MasonNormal  = { fg = c.fg, bg = c.bg_surface }
hl.MasonHeader  = { fg = c.bg, bg = c.amber }
hl.MasonHighlight = { fg = c.sky }
hl.MasonHighlightBlock = { fg = c.bg, bg = c.sky }
hl.MasonHighlightBlockBold = { fg = c.bg, bg = c.sky }
hl.MasonMutedBlock = { fg = c.fg_muted, bg = c.bg_raised }

-- ── Noice / Notify ──
hl.NoiceCmdlinePopup       = { fg = c.fg, bg = c.bg_surface }
hl.NoiceCmdlinePopupBorder = { fg = c.border_focus, bg = c.bg_surface }
hl.NoiceCmdlineIcon        = { fg = c.sky }
hl.NotifyERRORBorder = { fg = c.rose }
hl.NotifyWARNBorder  = { fg = c.amber }
hl.NotifyINFOBorder  = { fg = c.sky }
hl.NotifyDEBUGBorder = { fg = c.fg_muted }
hl.NotifyTRACEBorder = { fg = c.lilac }
hl.NotifyERRORIcon   = { fg = c.rose }
hl.NotifyWARNIcon    = { fg = c.amber }
hl.NotifyINFOIcon    = { fg = c.sky }
hl.NotifyDEBUGIcon   = { fg = c.fg_muted }
hl.NotifyTRACEIcon   = { fg = c.lilac }
hl.NotifyERRORTitle  = { fg = c.rose }
hl.NotifyWARNTitle   = { fg = c.amber }
hl.NotifyINFOTitle   = { fg = c.sky }
hl.NotifyDEBUGTitle  = { fg = c.fg_muted }
hl.NotifyTRACETitle  = { fg = c.lilac }

-- ── Which-Key ──
hl.WhichKey          = { fg = c.sky }
hl.WhichKeyGroup     = { fg = c.lilac }
hl.WhichKeySeparator = { fg = c.fg_faint }
hl.WhichKeyDesc      = { fg = c.fg_soft }
hl.WhichKeyFloat     = { bg = c.bg_surface }
hl.WhichKeyBorder    = { fg = c.border_focus, bg = c.bg_surface }
hl.WhichKeyValue     = { fg = c.fg_muted }

-- ── Flash.nvim ──
hl.FlashLabel   = { fg = c.bg, bg = c.amber }
hl.FlashCurrent = { fg = c.bg, bg = c.sky }
hl.FlashMatch   = { fg = c.fg, bg = c.bg_accent }

-- ── Mini (various) ──
hl.MiniIndentscopeSymbol = { fg = c.border_focus }

-- ── Trouble ──
hl.TroubleNormal     = { fg = c.fg, bg = c.bg_surface }
hl.TroubleNormalNC   = { fg = c.fg_soft, bg = c.bg_surface }

-- ── Snacks ──
hl.SnacksNormal      = { fg = c.fg, bg = c.bg }
hl.SnacksWinBar      = { fg = c.fg_soft, bg = c.bg }

-- ═══════════════════════════════════════════════════════════
-- APPLY
-- ═══════════════════════════════════════════════════════════

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end

vim.g.colors_name = "antigravity"
vim.o.termguicolors = true

for group, settings in pairs(hl) do
  vim.api.nvim_set_hl(0, group, settings)
end
