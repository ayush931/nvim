return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        style = "dark",
        transparent = false,
        -- Enable italic comment
        italic_comments = false,
        -- Disable nvim-tree background color
        disable_nvimtree_bg = false,
        -- Override colors or highlights
        group_overrides = {
          -- Example: ['@variable.builtin.python'] = { fg = '#569CD6' },
        },
      })
      require("vscode").load()
    end,
  },
}


