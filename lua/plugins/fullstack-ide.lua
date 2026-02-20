return { -- Language and tool coverage across web/mobile/ai-ml/web3/data stacks
{
    "mason-org/mason.nvim",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { -- LSPs
        "bash-language-server", "docker-compose-language-service", "dockerfile-language-server", "gopls",
        "graphql-language-service-cli", "json-lsp", "lua-language-server", "marksman", "prisma-language-server",
        "pyright", "ruff", "rust-analyzer", "sqlls", "taplo", "terraform-ls", "tflint", "yaml-language-server",

        -- Formatters / linters
        "black", "goimports", "isort", "prettierd", "shfmt", "stylua", "sqlfluff", -- DAP / debuggers
        "debugpy", "delve", "js-debug-adapter"})
    end
}, {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            bashls = {},
            dockerls = {},
            docker_compose_language_service = {},
            gopls = {
                mason = false,
                enabled = vim.fn.executable("gopls") == 1,
                settings = {
                    gopls = {
                        gofumpt = true,
                        usePlaceholders = true,
                        completeUnimported = true
                    }
                }
            },
            graphql = {},
            jsonls = {},
            lua_ls = {
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace"
                        },
                        diagnostics = {
                            globals = {"vim"}
                        }
                    }
                }
            },
            marksman = {},
            pyright = {},
            ruff = {
                mason = false,
                enabled = vim.fn.executable("ruff") == 1
            },
            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true
                        },
                        checkOnSave = true
                    }
                }
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
                            enable = true
                        }
                    }
                }
            }
        }
    }
}, {
    "mason-org/mason-lspconfig.nvim",
    optional = true,
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        opts.automatic_installation = opts.automatic_installation or false
        local blocked = {
            gopls = true,
            ruff = true
        }
        local filtered = {}
        for _, server in ipairs(opts.ensure_installed) do
            if not blocked[server] then
                table.insert(filtered, server)
            end
        end
        opts.ensure_installed = filtered
    end
}, {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed,
            {"bash", "c", "cpp", "css", "csv", "dockerfile", "go", "graphql", "html", "javascript", "jsdoc", "json",
             "json5", "jsonc", "lua", "markdown", "markdown_inline", "python", "regex", "rust", "sql", "terraform",
             "toml", "tsx", "typescript", "vim", "yaml"})
    end
}, -- Better formatting defaults for polyglot repos
{
    "stevearc/conform.nvim",
    optional = true,
    opts = {
        formatters_by_ft = {
            lua = {"stylua"},
            python = {"ruff_format", "isort", "black"},
            sh = {"shfmt"},
            bash = {"shfmt"},
            zsh = {"shfmt"},
            go = {"goimports", "gofmt"},
            rust = {"rustfmt"},
            terraform = {"terraform_fmt"},
            sql = {"sqlfluff"}
        }
    }
}, -- SQL and database workflows
{
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {"tpope/vim-dadbod", "kristijanhusak/vim-dadbod-completion"},
    cmd = {"DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer"},
    init = function()
        vim.g.db_ui_use_nerd_fonts = 1
        vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    end
}, -- AI assistant defaults
{
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    opts = {
        suggestion = {
            enabled = true,
            auto_trigger = true
        },
        panel = {
            enabled = false
        },
        filetypes = {
            markdown = true,
            help = true
        }
    }
}, {
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>a",
            group = "ai"
        }, {
            "<leader>d",
            group = "data/db"
        }, {
            "<leader>dd",
            "<cmd>DBUIToggle<cr>",
            desc = "Database UI"
        }}
    }
}}
