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
                            completeFunctionCalls = true,
                            autoImports = true,
                            classMemberSnippets = {
                                enabled = true
                            },
                            objectLiteralMethodSnippets = {
                                enabled = true
                            }
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all"
                            },
                            parameterTypes = {
                                enabled = true
                            },
                            variableTypes = {
                                enabled = false
                            },
                            propertyDeclarationTypes = {
                                enabled = true
                            },
                            functionLikeReturnTypes = {
                                enabled = true
                            },
                            enumMemberValues = {
                                enabled = true
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
                            completeFunctionCalls = true,
                            autoImports = true
                        },
                        inlayHints = {
                            parameterNames = {
                                enabled = "all"
                            },
                            parameterTypes = {
                                enabled = true
                            },
                            variableTypes = {
                                enabled = false
                            },
                            propertyDeclarationTypes = {
                                enabled = true
                            },
                            functionLikeReturnTypes = {
                                enabled = true
                            },
                            enumMemberValues = {
                                enabled = true
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
                on_new_config = function(new_config)
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    vim.list_extend(new_config.settings.json.schemas, require("schemastore").json.schemas({
                        extra = {{
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
        vim.list_extend(opts.ensure_installed, {"vtsls", "emmet-language-server", "tailwindcss-language-server",
                                                "css-lsp", "json-lsp", "eslint-lsp", "prettierd"})
    end
}, -- Formatting with Prettier (like VS Code default formatter)
{
    "stevearc/conform.nvim",
    optional = true,
    opts = {
        formatters_by_ft = {
            javascript = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            javascriptreact = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            typescript = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            typescriptreact = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            json = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            jsonc = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            html = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            css = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            scss = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            markdown = {
                "prettierd",
                "prettier",
                stop_after_first = true
            },
            yaml = {
                "prettierd",
                "prettier",
                stop_after_first = true
            }
        }
    }
}, -- Completion engine: VS Code-like behavior
{
    "saghen/blink.cmp",
    opts = {
        completion = {
            -- Trigger completion immediately as you type (like VS Code)
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
                -- Preselect first item like VS Code
                selection = {
                    preselect = true,
                    auto_insert = false
                }
            },
            -- Show completion menu automatically (like VS Code)
            menu = {
                auto_show = true,
                draw = {
                    columns = {{"kind_icon"}, {
                        "label",
                        "label_description",
                        gap = 1
                    }, {"source_name"}}
                }
            },
            -- Show documentation popup alongside completion (like VS Code)
            documentation = {
                auto_show = true,
                auto_show_delay_ms = 100
            },
            -- Ghost text (inline suggestion preview like VS Code)
            ghost_text = {
                enabled = true
            }
        },
        -- Show function signatures as you type (like VS Code)
        signature = {
            enabled = true
        },
        sources = {
            default = {"lsp", "path", "snippets", "buffer"},
            providers = {
                lsp = {
                    -- Don't wait — show LSP results as soon as they arrive
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
{"rafamadriz/friendly-snippets"}}
