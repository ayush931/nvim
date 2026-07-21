return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/.prettierrc.json"),
          },
        },
        shfmt = {
          prepend_args = { "-i", "4" },
        },
        stylua = {
          prepend_args = { "--indent-width", "4", "--indent-type", "Spaces" },
        },
      },
    },
  },
}
