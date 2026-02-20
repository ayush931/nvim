return { -- Turborepo keymaps
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>t",
            group = "turbo"
        }, {
            "<leader>tt",
            "<cmd>!pnpm turbo run dev<cr>",
            desc = "Turbo Dev"
        }, {
            "<leader>tb",
            "<cmd>!pnpm turbo run build<cr>",
            desc = "Turbo Build"
        }, {
            "<leader>tl",
            "<cmd>!pnpm turbo run lint<cr>",
            desc = "Turbo Lint"
        }, {
            "<leader>tc",
            "<cmd>!pnpm turbo run check-types<cr>",
            desc = "Turbo Type Check"
        }, {
            "<leader>te",
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
        "<leader>sw",
        function()
            require("telescope.builtin").live_grep({
                prompt_title = "Grep in Workspace Packages",
                search_dirs = {"packages", "apps"}
            })
        end,
        desc = "Grep (packages/apps)"
    }}
}, -- Make vtsls understand monorepo workspace packages for auto-imports
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            vtsls = {
                settings = {
                    vtsls = {
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true
                            }
                        }
                    },
                    typescript = {
                        preferences = {
                            -- Use workspace-relative imports (@repo/ui, @repo/utils)
                            importModuleSpecifier = "non-relative",
                            -- Prefer the project's path aliases
                            importModuleSpecifierEnding = "minimal"
                        },
                        -- Suggest auto-imports from all workspace packages
                        suggest = {
                            autoImports = true,
                            completeFunctionCalls = true,
                            includeCompletionsForModuleExports = true,
                            includeCompletionsWithSnippetText = true
                        },
                        -- Rename imports when moving files across packages
                        updateImportsOnFileMove = {
                            enabled = "always"
                        },
                        tsserver = {
                            maxTsServerMemory = 8192
                        }
                    },
                    javascript = {
                        suggest = {
                            autoImports = true,
                            completeFunctionCalls = true,
                            includeCompletionsForModuleExports = true
                        }
                    }
                }
            }
        }
    }
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
