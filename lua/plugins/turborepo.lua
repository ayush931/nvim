return { -- Turborepo keymaps
    {
        "folke/which-key.nvim",
        opts = function(_, opts)
            local function turbo_term(cmd)
                require("config.terminals").toggle(cmd)
            end
            opts.spec = opts.spec or {}
            vim.list_extend(opts.spec, {
                {
                    "<leader>T",
                    group = "turbo",
                },
                {
                    "<leader>Tt",
                    function()
                        turbo_term("pnpm turbo run dev")
                    end,
                    desc = "Turbo Dev",
                },
                {
                    "<leader>Tb",
                    function()
                        turbo_term("pnpm turbo run build")
                    end,
                    desc = "Turbo Build",
                },
                {
                    "<leader>Tl",
                    function()
                        turbo_term("pnpm turbo run lint")
                    end,
                    desc = "Turbo Lint",
                },
                {
                    "<leader>Tc",
                    function()
                        turbo_term("pnpm turbo run check-types")
                    end,
                    desc = "Turbo Type Check",
                },
                {
                    "<leader>Te",
                    function()
                        turbo_term("pnpm turbo run test")
                    end,
                    desc = "Turbo Test",
                },
            })
            return opts
        end,
    }, -- Monorepo-aware file navigation with telescope
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            {
                "<leader>fw",
                function()
                    local root, dirs = require("config.project").workspace_dirs()
                    require("telescope.builtin").find_files({
                        prompt_title = "Find in Workspace Packages",
                        cwd = root,
                        search_dirs = dirs,
                    })
                end,
                desc = "Find Files (packages/apps)",
            },
            {
                "<leader>sp",
                function()
                    local root, dirs = require("config.project").workspace_dirs()
                    require("telescope.builtin").live_grep({
                        prompt_title = "Grep in Workspace Packages",
                        cwd = root,
                        search_dirs = dirs,
                    })
                end,
                desc = "Grep (packages/apps)",
            },
        },
    }, -- ESLint integration scoped to workspace (respects root eslint config)
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                eslint = {
                    filetypes = {
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                        "vue",
                        "svelte",
                        "astro",
                    },
                    settings = {
                        workingDirectories = {
                            mode = "auto",
                        },
                    },
                },
            },
        },
    },
}
