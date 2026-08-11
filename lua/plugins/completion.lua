return { -- Use vtsls (wraps VS Code's TypeScript extension) for identical suggestions
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            -- Disable ts_ls in favor of vtsls
            ts_ls = {
                enabled = false
            },

            -- Disable cspell_ls (incompatible dynamic registration causes nil index error)
            cspell_ls = {
                enabled = false
            },

            -- Disable custom_elements_ls (same dynamic registration issue)
            custom_elements_ls = {
                enabled = false
            },

            -- Disable tsgo (same dynamic registration issue)
            tsgo = {
                enabled = false
            },

            -- Disable grammar/spell checkers in comments
            harper_ls = {
                enabled = false
            },
            ltex = {
                enabled = false
            },
            typos_lsp = {
                enabled = false
            },

            -- Disable emmet_ls in favor of emmet_language_server
            emmet_ls = {
                enabled = false
            },

            -- vtsls: VS Code's TypeScript language service for Neovim
            vtsls = {
                settings = {
                    typescript = {
                        updateImportsOnFileMove = {
                            enabled = "always"
                        },
                        suggest = {
                            completeFunctionCalls = false,
                            autoImports = true,
                            classMemberSnippets = {
                                enabled = false
                            },
                            objectLiteralMethodSnippets = {
                                enabled = false
                            }
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "none"
                            },
                            parameterTypes = {
                                enabled = false
                            },
                            variableTypes = {
                                enabled = false
                            },
                            propertyDeclarationTypes = {
                                enabled = false
                            },
                            functionLikeReturnTypes = {
                                enabled = false
                            },
                            enumMemberValues = {
                                enabled = false
                            }
                        },
                        preferences = {
                            importModuleSpecifier = "non-relative",
                            importModuleSpecifierEnding = "minimal",
                            autoImportFileExcludePatterns = {"node_modules/.cache/**"}
                        },
                        tsserver = {
                            maxTsServerMemory = 4096
                        }
                    },
                    javascript = {
                        updateImportsOnFileMove = {
                            enabled = "always"
                        },
                        suggest = {
                            completeFunctionCalls = false,
                            autoImports = true
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "none"
                            },
                            parameterTypes = {
                                enabled = false
                            },
                            variableTypes = {
                                enabled = false
                            },
                            propertyDeclarationTypes = {
                                enabled = false
                            },
                            functionLikeReturnTypes = {
                                enabled = false
                            },
                            enumMemberValues = {
                                enabled = false
                            }
                        }
                    },
                    vtsls = {
                        enableMoveToFileCodeAction = true,
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true,
                                entriesLimit = 300
                            }
                        },
                        tsserver = {
                            globalPlugins = {}
                        }
                    }
                },
                -- Make vtsls aware of monorepo project references
                root_markers = {"tsconfig.json", "package.json", "turbo.json", ".git"}
            },

            -- Emmet completions for JSX/TSX (like VS Code built-in)
            emmet_language_server = {
                filetypes = {"html", "css", "scss", "javascriptreact", "typescriptreact", "svelte", "vue"}
            },

            -- Tailwind CSS IntelliSense (class suggestions like VS Code extension)
            tailwindcss = {
                filetypes = {"html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact",
                             "svelte", "vue"},
                settings = {
                    tailwindCSS = {
                        experimental = {
                            classRegex = {{"cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"},
                                          {"cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)"},
                                          {"cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)"},
                                          {"clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)"}}
                        },
                        validate = true
                    }
                }
            },

            -- CSS hover info and completions
            cssls = {},

            -- JSON schemas: turbo.json, tsconfig, package.json etc.
            jsonls = {
                before_init = function(_, new_config)
                    new_config.settings.json = new_config.settings.json or {}
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas({
                        extra = {{
                            name = "turbo.json",
                            fileMatch = {"turbo.json"},
                            url = "https://turbo.build/schema.json"
                        }}
                    }))
                end,
                settings = {
                    json = {
                        validate = {
                            enable = true
                        }
                    }
                }
            }
        }
    }
}, -- SchemaStore: catalog of JSON/YAML schemas (package.json, tsconfig, etc.)
{
    "b0o/schemastore.nvim",
    lazy = true
}, -- Mason: auto-install all required servers
{
    "mason-org/mason.nvim",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed,
            {"vtsls", "emmet-language-server", "tailwindcss-language-server", "css-lsp", "eslint-lsp", "prettier"})
        return opts
    end
}, -- Formatting with Prettier (like VS Code default formatter)
{
    "stevearc/conform.nvim",
    optional = true,
    opts = {
        formatters_by_ft = {
            javascript = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            javascriptreact = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            typescript = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            typescriptreact = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            json = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            jsonc = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            html = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            css = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            scss = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            markdown = {
                "prettier",
                "prettierd",
                stop_after_first = true
            },
            yaml = {
                "prettier",
                "prettierd",
                stop_after_first = true
            }
        }
    }
}, -- Clean, non-intrusive completion engine (blink.cmp)
{
    "saghen/blink.cmp",
    opts = {
        keymap = {
            preset = "super-tab",
            ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
            ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
            ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
            ["<C-space>"] = { "show_documentation", "hide_documentation", "fallback" },
            ["<C-d>"] = { "show_documentation", "hide_documentation", "fallback" },
            ["<C-f>"] = { "scroll_documentation_down", "fallback" },
            ["<C-b>"] = { "scroll_documentation_up", "fallback" },
        },
        completion = {
            accept = {
                auto_brackets = {
                    enabled = true
                }
            },
            keyword = {
                range = "full"
            },
            trigger = {
                show_on_keyword = true,
                show_on_trigger_character = true,
                show_on_insert_on_trigger_character = true,
                show_on_accept_on_trigger_character = true
            },
            list = {
                selection = {
                    preselect = false,
                    auto_insert = false
                }
            },
            -- Clean, rounded completion menu with max height limit
            menu = {
                auto_show = true,
                border = "rounded",
                max_height = 10,
                draw = {
                    columns = {{"kind_icon"}, {
                        "label",
                        "label_description",
                        gap = 1
                    }, {"source_name"}}
                }
            },
            -- Don't auto-popup huge documentation box on every single keypress
            documentation = {
                auto_show = false,
                auto_show_delay_ms = 500,
                window = {
                    border = "rounded"
                }
            },
            -- Disable ghost text (inline grey preview text in front of cursor)
            ghost_text = {
                enabled = false
            }
        },
        -- Disable automatic function signature popup when typing functions like push_back(
        signature = {
            enabled = false,
            window = {
                border = "rounded"
            }
        },
        sources = {
            default = {"lsp", "path", "snippets", "buffer"},
            providers = {
                lsp = {
                    async = true,
                    score_offset = 100
                },
                path = {
                    score_offset = 80
                },
                snippets = {
                    score_offset = 70
                },
                buffer = {
                    score_offset = 50,
                    min_keyword_length = 3
                }
            }
        }
    }
}, -- Snippets: friendly-snippets gives VS Code-like snippet library
{"rafamadriz/friendly-snippets"},
-- Disable separate lsp_signature plugin to avoid double floating windows (blink.cmp handles signature cleanly)
{
    "ray-x/lsp_signature.nvim",
    enabled = false
}}

