return {
  {
    "Mofiqul/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("vscode").setup({
        style = "dark",
        -- Enable transparent background if you prefer
        -- transparent = true,
        -- Enable italic comment
        italic_comments = true,
        -- Disable nvim-tree background color
        disable_nvimtree_bg = true,
        -- Override colors or highlights
        group_overrides = {
          -- Example: ['@variable.builtin.python'] = { fg = '#569CD6' },
        },
      })
      require("vscode").load()
    end,
  },
}
