return { -- Language and tool coverage across web/mobile/ai-ml/web3/data stacks
    {
        "mason-org/mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            -- Language servers are installed by mason-lspconfig. Listing them here
            -- as well starts competing installs of the same package.
            vim.list_extend(opts.ensure_installed, {
                "black",
                "clang-format",
                "goimports",
                "isort",
                "prettierd",
                "shfmt",
                "stylua",
                "sqlfluff",
                "debugpy",
                "delve",
                "js-debug-adapter",
            })
            opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
            return opts
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                bashls = {},
                clangd = {
                    -- Negotiate UTF-16 using the standard LSP capability.
                    -- Full sync avoids invalid incremental ranges dropping the draft
                    -- after Unicode edits (and subsequent "non-added document" errors).
                    capabilities = {
                        general = { positionEncodings = { "utf-16" } },
                    },
                    before_init = function(params)
                        -- nvim-lspconfig adds this deprecated extension by default.
                        -- clangd 23 uses general.positionEncodings instead.
                        params.capabilities.offsetEncoding = nil
                    end,
                    flags = { allow_incremental_sync = false },
                    cmd = {
                        "clangd",
                        "--background-index",
                        "-j=2",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders=1",
                        "--fallback-style={BasedOnStyle: Google, IndentWidth: 4, TabWidth: 4, UseTab: Never, ColumnLimit: 0, AccessModifierOffset: -4}",
                    },
                },
                dockerls = {},
                docker_compose_language_service = {},
                gopls = {
                    mason = false,
                    enabled = vim.fn.executable("gopls") == 1,
                    settings = {
                        gopls = {
                            gofumpt = true,
                            usePlaceholders = true,
                            completeUnimported = true,
                            analyses = {
                                unusedparams = true,
                                shadow = true,
                                nilness = true,
                                unusedwrite = true,
                            },
                            hints = {
                                assignVariableTypes = true,
                                compositeLiteralFields = true,
                                compositeLiteralTypes = true,
                                constantValues = true,
                                functionTypeParameters = true,
                                parameterNames = true,
                                rangeVariableTypes = true,
                            },
                            staticcheck = true,
                            semanticTokens = true,
                        },
                    },
                },
                graphql = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            completion = {
                                callSnippet = "Replace",
                            },
                            diagnostics = {
                                globals = { "vim" },
                            },
                        },
                    },
                },
                marksman = {},
                basedpyright = {
                    settings = {
                        basedpyright = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                            },
                        },
                    },
                },
                ruff = {
                    mason = false,
                    enabled = vim.fn.executable("ruff") == 1,
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = true,
                        },
                    },
                },
                sqlls = {},
                taplo = {},
                terraformls = {},
                tflint = {},
                yamlls = {
                    settings = {
                        yaml = {
                            keyOrdering = false,
                            format = {
                                enable = true,
                            },
                        },
                    },
                },
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "bash",
                "c",
                "cpp",
                "css",
                "csv",
                "dockerfile",
                "go",
                "gomod",
                "gosum",
                "gowork",
                "graphql",
                "html",
                "javascript",
                "jsdoc",
                "json",
                "json5",
                "lua",
                "markdown",
                "markdown_inline",
                "python",
                "regex",
                "rust",
                "sql",
                "terraform",
                "toml",
                "tsx",
                "typescript",
                "vim",
                "yaml",
            })
            opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
            return opts
        end,
    }, -- Better formatting defaults for polyglot repos
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "isort", "black" },
                sh = { "shfmt" },
                bash = { "shfmt" },
                go = { "goimports", "gofmt" },
                rust = { "rustfmt" },
                terraform = { "terraform_fmt" },
                sql = { "sqlfluff" },
            },
        },
    }, -- SQL and database workflows
    {
        "kristijanhusak/vim-dadbod-ui",
        dependencies = { "tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion" },
        cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
        init = function()
            vim.g.db_ui_use_nerd_fonts = 1
            vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
        end,
    },
    {
        "folke/which-key.nvim",
        opts = {
            spec = {
                {
                    "<leader>d",
                    group = "debug/data",
                },
                {
                    "<leader>dd",
                    "<cmd>DBUIToggle<cr>",
                    desc = "Database UI",
                },
            },
        },
    },
}
