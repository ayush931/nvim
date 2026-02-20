return {
  -- Python virtualenv switcher for ML/data-science projects
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    cmd = { "VenvSelect", "VenvSelectCached" },
    opts = {
      name = { "venv", ".venv", "env", ".env" },
      auto_refresh = true,
    },
    keys = {
      { "<leader>av", "<cmd>VenvSelect<cr>", desc = "Select Python venv" },
      { "<leader>aV", "<cmd>VenvSelectCached<cr>", desc = "Use cached Python venv" },
    },
  },

  -- Python debugging with debugpy
  {
    "mfussenegger/nvim-dap-python",
    ft = { "python" },
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(debugpy)
    end,
    keys = {
      { "<leader>ap", function() require("dap-python").test_method() end, desc = "Debug Python test method" },
      { "<leader>aP", function() require("dap-python").test_class() end, desc = "Debug Python test class" },
    },
  },

  -- Better CSV viewing for analytics/data work
  {
    "hat0uma/csvview.nvim",
    ft = { "csv", "tsv" },
    opts = {
      parser = { comments = { "#", "//" } },
      view = { spacing = 1, display_mode = "border" },
    },
  },

  -- Quick REPL integration for experiments
  {
    "Vigemus/iron.nvim",
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    keys = {
      { "<leader>ar", "<cmd>IronRepl<cr>", desc = "Open REPL" },
      { "<leader>af", "<cmd>IronFocus<cr>", desc = "Focus REPL" },
      { "<leader>as", "<cmd>IronHide<cr>", desc = "Hide REPL" },
    },
    opts = {
      config = {
        scratch_repl = true,
        repl_definition = {
          python = { command = { "python3" } },
          javascript = { command = { "node" } },
          typescript = { command = { "node" } },
        },
      },
      keymaps = {
        send_motion = "<leader>sc",
        visual_send = "<leader>sc",
        send_file = "<leader>sf",
        send_line = "<leader>sl",
      },
    },
  },
}
