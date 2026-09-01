return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "prodev",
    },
  },
  {
    "prodev",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme prodev")
    end,
  },
}
