return {
  {
    "mfussenegger/nvim-dap",
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {
      adapters = { "pwa-node", "pwa-chrome" },
    },
  },
}