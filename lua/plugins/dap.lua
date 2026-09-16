return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap-python",
      "nvim-neotest/nvim-nio",
    },
    lazy = true,
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
      { "<leader>do", function() require("dap").step_over() end, desc = "Step Over" },
      { "<leader>dO", function() require("dap").step_out() end, desc = "Step Out" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate DAP" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- Python-specific DAP config with safe path resolution
      local mason_py = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      local sys_py = vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
      local python_path = vim.fn.filereadable(mason_py) == 1 and mason_py or sys_py
      pcall(function()
        require("dap-python").setup(python_path)
      end)

      -- JavaScript / TypeScript / React Native DAP adapter (pwa-node)
      -- Guarded: only register when node + mason's dapDebugServer.js both exist.
      -- Previously this unconditionally pointed at a possibly-missing file, so
      -- starting a JS debug session failed with ENOENT instead of a clear skip.
      local js_debug_adapter = vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
      if vim.fn.executable("node") == 1 and vim.fn.filereadable(js_debug_adapter) == 1 then
        dap.adapters["pwa-node"] = dap.adapters["pwa-node"] or {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            args = { js_debug_adapter, "${port}" },
          },
        }

        -- Share the same JS configs across every JS/TS filetype (previously only
        -- typescriptreact got one, so plain js/ts/jsx debugging had no config).
        local js_filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
        local js_configs = {
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach to React Native (Metro :8081)",
            port = 8081,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch current file (node)",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
          },
        }
        for _, ft in ipairs(js_filetypes) do
          dap.configurations[ft] = dap.configurations[ft] or {}
          -- Avoid duplicating configs on reload: check by name first.
          for _, conf in ipairs(js_configs) do
            local exists = false
            for _, cur in ipairs(dap.configurations[ft]) do
              if cur.name == conf.name then
                exists = true
                break
              end
            end
            if not exists then
              table.insert(dap.configurations[ft], conf)
            end
          end
        end
      end
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    lazy = true,
    opts = {
      adapters = { "pwa-node", "pwa-chrome" },
    },
  },
}