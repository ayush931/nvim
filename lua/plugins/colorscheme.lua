return {
  -- Add the VS Code theme plugin
  {
    "Mofiqul/vscode.nvim",
    -- Make sure this loads first
    lazy = false,
    priority = 1000,
    opts = {
      -- Set the style to "dark" or "light" as desired
      style = "dark",

      -- Enable transparent background if you want
      transparent = false,

      -- Adjust specific colors if needed (optional)
      color_overrides = {},

      -- Configure which plugins this theme should integrate with
      integrations = {
        telescope = true,
        nvimtree = true,
        cmp = true,
        gitsigns = true,
        lualine = true,
      },
    },
    -- Load the colorscheme on startup
    config = function()
      vim.cmd("colorscheme vscode")
    end,
  },
}