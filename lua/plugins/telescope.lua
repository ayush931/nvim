return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-ui-select.nvim",
      "nvim-telescope/telescope-live-grep-args.nvim",
    },
    keys = {
      -- Override search keys to run from project root directory by default
      {
        "<leader>ff",
        function()
          require("telescope.builtin").find_files({ cwd = _G.get_project_root(), hidden = true })
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fF",
        function()
          require("telescope.builtin").find_files({ cwd = vim.uv.cwd(), hidden = true })
        end,
        desc = "Find Files (cwd)",
      },
      {
        "<leader><space>",
        function()
          require("telescope.builtin").find_files({ cwd = _G.get_project_root(), hidden = true })
        end,
        desc = "Find Files (Root Dir)",
      },
      {
        "<leader>fW",
        function()
          require("telescope").extensions.live_grep_args.live_grep_args({ cwd = _G.get_project_root() })
        end,
        desc = "Live Grep (Args - Root Dir)",
      },
      {
        "<leader>fr",
        function()
          require("telescope.builtin").oldfiles()
        end,
        desc = "Recent Files",
      },
      {
        "<leader>fk",
        function()
          require("telescope.builtin").keymaps()
        end,
        desc = "Keymaps",
      },
    },
    opts = function(_, opts)
      opts.defaults = opts.defaults or {}
      opts.defaults.color_devicons = true
      opts.defaults.file_ignore_patterns = vim.list_extend(opts.defaults.file_ignore_patterns or {}, {
        "node_modules",
        ".git/",
        "dist",
        ".next",
        "build",
        "coverage",
        ".turbo",
      })

      opts.defaults.layout_strategy = "horizontal"
      opts.defaults.layout_config = vim.tbl_deep_extend("force", opts.defaults.layout_config or {}, {
        horizontal = { preview_width = 0.55 },
        prompt_position = "top",
      })
      opts.defaults.path_display = { "truncate" }
      opts.defaults.sorting_strategy = "ascending"

      opts.extensions = opts.extensions or {}
      opts.extensions["ui-select"] = require("telescope.themes").get_dropdown({})
      opts.extensions.live_grep_args = {
        auto_quoting = true,
      }
      return opts
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("ui-select")
      telescope.load_extension("live_grep_args")
    end,
  },

  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>f", group = "file/find" },
      },
    },
  },
}
