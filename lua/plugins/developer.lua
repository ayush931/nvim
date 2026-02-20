return {
  -- Refactoring: extract function/variable, inline variable, etc.
  {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    keys = {
      { "<leader>re", function() require("refactoring").refactor("Extract Function") end, desc = "Extract Function", mode = "v" },
      { "<leader>rv", function() require("refactoring").refactor("Extract Variable") end, desc = "Extract Variable", mode = "v" },
      { "<leader>ri", function() require("refactoring").refactor("Inline Variable") end, desc = "Inline Variable", mode = { "n", "v" } },
      { "<leader>rb", function() require("refactoring").refactor("Extract Block") end, desc = "Extract Block" },
      {
        "<leader>rr",
        function() require("refactoring").select_refactor() end,
        desc = "Select Refactor",
        mode = { "n", "v" },
      },
    },
    opts = {},
  },

  -- Illuminate: auto-highlight other occurrences of word under cursor
  {
    "RRethy/vim-illuminate",
    event = "LspAttach",
    opts = {
      delay = 200,
      large_file_cutoff = 2000,
      large_file_overrides = { providers = { "lsp" } },
    },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- Aerial: code outline / symbol sidebar (lightweight alternative to lspsaga outline)
  {
    "stevearc/aerial.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      backends = { "lsp", "treesitter", "markdown", "man" },
      layout = {
        max_width = { 40, 0.2 },
        min_width = 20,
      },
      show_guides = true,
      filter_kind = false,
    },
    keys = {
      { "<leader>cs", "<cmd>AerialToggle<CR>", desc = "Symbol Outline (Aerial)" },
      { "<leader>cS", "<cmd>AerialNavToggle<CR>", desc = "Symbol Nav (Aerial)" },
    },
  },

  -- Glance: peek definition/references/implementations in a floating window
  {
    "dnlhc/glance.nvim",
    cmd = "Glance",
    opts = {
      border = { enable = true },
      height = 18,
      zindex = 45,
    },
    keys = {
      { "gR", "<cmd>Glance references<CR>", desc = "Glance References" },
      { "gM", "<cmd>Glance implementations<CR>", desc = "Glance Implementations" },
      { "gY", "<cmd>Glance type_definitions<CR>", desc = "Glance Type Definition" },
    },
  },

  -- Regexplainer: explain regex under cursor in a popup
  {
    "bennypowers/nvim-regexplainer",
    dependencies = { "nvim-treesitter/nvim-treesitter", "MunifTanjim/nui.nvim" },
    keys = {
      { "<leader>cx", function() require("regexplainer").toggle() end, desc = "Explain Regex" },
    },
    opts = {
      auto = false,
      filetypes = {
        "typescript",
        "typescriptreact",
        "javascript",
        "javascriptreact",
      },
      mappings = { toggle = "<leader>cx" },
    },
  },

  -- Which-key group labels for new keymaps
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>r", group = "refactor" },
      },
    },
  },
}
