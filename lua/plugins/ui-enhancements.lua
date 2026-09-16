-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   UI Enhancement Plugins                   ║
-- ╚══════════════════════════════════════════════════════════════╝

return {
  { "folke/snacks.nvim", opts = { dashboard = { enabled = false } } },

  -- Required stub: bufferline.nvim is a LazyVim core plugin. This entry does
  -- not install anything; it keeps the core plugin disabled. Deleting this
  -- line would re-enable LazyVim's default bufferline.
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
