return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      style = "dark", -- VS Code Dark Modern theme
      transparent = false,
      italic_comments = true,
      underline_links = true,
      disable_nvimtree_bg = true,
      terminal_colors = true,
      color_overrides = {
        vscLineNumber = "#5A6A80",
        vscCursorDark = "#FFFFFF",
      },
      group_overrides = {
        FloatBorder = { fg = "#3C445C", bg = "#181A1F" },
        NormalFloat = { fg = "#D4D4D4", bg = "#181A1F" },
        TelescopeBorder = { fg = "#3C445C", bg = "#181A1F" },
        TelescopePromptBorder = { fg = "#007ACC", bg = "#181A1F" },
        TelescopePromptTitle = { fg = "#FFFFFF", bg = "#007ACC", bold = true },
        TelescopeNormal = { fg = "#D4D4D4", bg = "#181A1F" },
        Pmenu = { fg = "#D4D4D4", bg = "#1E1E1E" },
        PmenuSel = { fg = "#FFFFFF", bg = "#04395E" },
        CursorLine = { bg = "#22262E" },
        IblIndent = { fg = "#282C34" },
        IblScope = { fg = "#4B5263" },
      },
    },
    config = function(_, opts)
      local vscode = require("vscode")
      vscode.setup(opts)
      vscode.load()
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "vscode",
    },
  },
}
