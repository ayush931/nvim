return { -- Turborepo keymaps
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>T",
            group = "turbo"
        }, {
            "<leader>Tt",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "pnpm turbo run dev",
                    direction = "float",
                    close_on_exit = false,
                }):toggle()
            end,
            desc = "Turbo Dev"
        }, {
            "<leader>Tb",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "pnpm turbo run build",
                    direction = "float",
                    close_on_exit = false,
                }):toggle()
            end,
            desc = "Turbo Build"
        }, {
            "<leader>Tl",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "pnpm turbo run lint",
                    direction = "float",
                    close_on_exit = false,
                }):toggle()
            end,
            desc = "Turbo Lint"
        }, {
            "<leader>Tc",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "pnpm turbo run check-types",
                    direction = "float",
                    close_on_exit = false,
                }):toggle()
            end,
            desc = "Turbo Type Check"
        }, {
            "<leader>Te",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "pnpm turbo run test",
                    direction = "float",
                    close_on_exit = false,
                }):toggle()
            end,
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
