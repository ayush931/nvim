return { -- Treesitter for better syntax highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "prisma" })
            opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
            return opts
        end,
    }, -- LSP configuration for Prisma
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                prismals = {},
            },
        },
    },
}
