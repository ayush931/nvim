return { -- Turborepo keymaps
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>T",
            group = "turbo"
        }, {
            "<leader>Tt",
            "<cmd>!pnpm turbo run dev<cr>",
            desc = "Turbo Dev"
        }, {
            "<leader>Tb",
            "<cmd>!pnpm turbo run build<cr>",
            desc = "Turbo Build"
        }, {
            "<leader>Tl",
            "<cmd>!pnpm turbo run lint<cr>",
            desc = "Turbo Lint"
        }, {
            "<leader>Tc",
            "<cmd>!pnpm turbo run check-types<cr>",
            desc = "Turbo Type Check"
        }, {
            "<leader>Te",
            "<cmd>!pnpm turbo run test<cr>",
            desc = "Turbo Test"
        }}
    }
}, -- Monorepo-aware file navigation with telescope
{
    "nvim-telescope/telescope.nvim",
    keys = {{
        "<leader>fw",
        function()
            require("telescope.builtin").find_files({
                prompt_title = "Find in Workspace Packages",
                search_dirs = {"packages", "apps"}
            })
        end,
        desc = "Find Files (packages/apps)"
    }, {
        "<leader>sp",
        function()
            require("telescope.builtin").live_grep({
                prompt_title = "Grep in Workspace Packages",
                search_dirs = {"packages", "apps"}
            })
        end,
        desc = "Grep (packages/apps)"
    }}
}, -- ESLint integration scoped to workspace (respects root eslint config)
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            eslint = {
                settings = {
                    workingDirectories = {
                        mode = "auto"
                    }
                }
            }
        }
    }
}}
