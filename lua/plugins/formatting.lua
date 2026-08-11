return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        cpp = { "clang-format" },
        c = { "clang-format" },
      },
      formatters = {
        prettier = {
          prepend_args = { "--tab-width", "4" },
        },
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/.prettierrc.json"),
          },
          prepend_args = { "--tab-width", "4" },
        },
        shfmt = {
          prepend_args = { "-i", "4" },
        },
        stylua = {
          prepend_args = { "--indent-width", "4", "--indent-type", "Spaces" },
        },
        ["clang-format"] = {
          prepend_args = { "-style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never}" },
        },
      },
    },
  },
}
