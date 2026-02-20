return { -- Prisma syntax highlighting plugin
{
    "prisma/vim-prisma",
    ft = "prisma"
}, -- Treesitter for better syntax highlighting
{
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {"prisma"})
    end
}, -- LSP configuration for Prisma
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            prismals = {
                settings = {
                    prisma = {
                        prismaFmtBinPath = ""
                    }
                }
            }
        }
    }
}, -- Mason to install prisma-language-server
{
    "mason-org/mason.nvim",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {"prisma-language-server"})
    end
}, -- Formatting with conform.nvim
{
    "stevearc/conform.nvim",
    optional = true,
    opts = {
        formatters_by_ft = {
            prisma = {"prismaFmt"}
        }
    }
}}