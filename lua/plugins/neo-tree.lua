return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    keys = {
      {
        "<leader>e",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = _G.get_project_root() })
        end,
        desc = "Explorer NeoTree (Root Dir)",
      },
      {
        "<leader>E",
        function()
          require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
        end,
        desc = "Explorer NeoTree (cwd)",
      },
    },
    opts = {
      default_component_configs = {
        indent = {
          indent_size = 2,
          padding = 1,
          with_expanders = true,
        },
      },
      filesystem = {
        bind_to_cwd = false,
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_hidden = false,
        },
        follow_current_file = {
          enabled = false,
          leave_dirs_open = false,
        },
        window = {
          mappings = {
            ["<space>"] = "none",
          },
        },
      },
      event_handlers = {
        {
          event = "file_added",
          handler = function(path)
            if vim.fn.isdirectory(path) == 0 then
              vim.cmd("edit " .. vim.fn.fnameescape(path))
            end
          end,
        },
      },
    },
  },
}
