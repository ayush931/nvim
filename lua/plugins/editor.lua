return {
  -- Floating terminal for quick commands
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-\\>", desc = "Toggle Terminal" },
      { "<leader>tf", function() require("toggleterm").toggle(0, nil, nil, "float") end, desc = "Float Terminal" },
      { "<leader>th", function() require("toggleterm").toggle(0, 15, nil, "horizontal") end, desc = "Horizontal Terminal" },
      { "<leader>tv", function() require("toggleterm").toggle(0, 80, nil, "vertical") end, desc = "Vertical Terminal" },
    },
    opts = {
      open_mapping = [[<C-\>]],
      direction = "float",
      float_opts = {
        border = "curved",
      },
      shade_terminals = true,
    },
  },

  -- Highlight and search TODO/FIXME/HACK comments (extend LazyVim built-in)
  {
    "folke/todo-comments.nvim",
    opts = {
      highlight = {
        multiline = true,
        comments_only = true,
      },
    },
  },

  -- Better diagnostics list with workspace-wide errors
  {
    "folke/trouble.nvim",
    opts = {
      focus = true,
      auto_preview = true,
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      mappings = { "<C-u>", "<C-d>", "<C-b>", "<C-f>", "zt", "zz", "zb" },
      hide_cursor = false,
      stop_eof = true,
      respect_scrolloff = true,
    },
  },

  -- Highlight color codes inline (#fff, rgb, hsl)
  {
    "brenoprata10/nvim-highlight-colors",
    event = "BufReadPre",
    opts = {
      render = "virtual",
      enable_tailwind = true,
    },
  },
}
