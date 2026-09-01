-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   UI Enhancement Plugins                   ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },

  { "akinsho/bufferline.nvim", enabled = false },

  -- Keep only essentials to reduce UI noise and startup overhead.
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = {
        char = "│",
        tab_char = "│",
        highlight = "IblIndent",
      },
      scope = {
        enabled = true,
        char = "│",
        show_start = false,
        show_end = false,
        highlight = "IblScope",
        priority = 1024,
      },
      exclude = {
        filetypes = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
      },
    },
  },
}
