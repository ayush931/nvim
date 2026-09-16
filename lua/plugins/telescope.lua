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
          local cwd = (vim.uv or vim.loop).cwd() or vim.fn.getcwd()
          require("telescope.builtin").find_files({ cwd = cwd, hidden = true })
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
      -- Dedupe on every evaluation: this opts func can run more than once
      -- (lazy reload), and plain list_extend would stack duplicates.
      opts.defaults.file_ignore_patterns = opts.defaults.file_ignore_patterns or {}
      local seen = {}
      for _, p in ipairs(opts.defaults.file_ignore_patterns) do
        seen[p] = true
      end
      for _, p in ipairs({
        "node_modules",
        ".git/",
        "dist",
        ".next",
        "build",
        "coverage",
        ".turbo",
      }) do
        if not seen[p] then
          table.insert(opts.defaults.file_ignore_patterns, p)
          seen[p] = true
        end
      end

      opts.defaults.layout_strategy = "horizontal"
      opts.defaults.layout_config = vim.tbl_deep_extend("force", opts.defaults.layout_config or {}, {
        horizontal = { preview_width = 0.55 },
        prompt_position = "top",
      })
      opts.defaults.path_display = { "truncate" }
      opts.defaults.sorting_strategy = "ascending"

      opts.extensions = opts.extensions or {}
      local ok_themes, themes = pcall(require, "telescope.themes")
      if ok_themes and themes then
        local ok_dd, dropdown = pcall(themes.get_dropdown, {})
        if ok_dd and dropdown then
          opts.extensions["ui-select"] = dropdown
        end
      end
      opts.extensions.live_grep_args = {
        auto_quoting = true,
      }
      return opts
    end,
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      -- pcall: missing/failed extensions previously aborted telescope setup.
      pcall(telescope.load_extension, "ui-select")
      pcall(telescope.load_extension, "live_grep_args")
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
