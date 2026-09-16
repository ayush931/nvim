return { -- Use vtsls (wraps VS Code's TypeScript extension) for identical suggestions
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            -- Disable ts_ls in favor of vtsls
            ts_ls = {
                enabled = false
            },

            -- Disable emmet_ls in favor of emmet_language_server
            emmet_ls = {
                enabled = false
            },

            -- vtsls: VS Code's TypeScript language service for Neovim (optimized for zero typing lag)
            vtsls = {
                -- Resolve the server binary safely at setup time.
                -- Prefer a PATH binary (mason/bin is added to PATH in options.lua),
                -- then mason's bundled vtsls.js via node/bun, else nil so lspconfig
                -- falls back to its default cmd resolution (avoids spawning a
                -- non-existent file, which previously broke JS/TS LSP silently).
                cmd = (function()
                    if vim.fn.executable("vtsls") == 1 then
                        return { "vtsls", "--stdio" }
                    end
                    local vtsls_js = vim.fn.stdpath("data")
                        .. "/mason/packages/vtsls/node_modules/@vtsls/language-server/bin/vtsls.js"
                    if vim.fn.filereadable(vtsls_js) == 1 then
                        if vim.fn.executable("node") == 1 then
                            return { "node", vtsls_js, "--stdio" }
                        end
                        local bun = vim.fn.expand("~/.bun/bin/bun")
                        if vim.fn.executable(bun) == 1 then
                            return { bun, vtsls_js, "--stdio" }
                        end
                    end
                    return nil
                end)(),
                settings = {
                    typescript = {
                        updateImportsOnFileMove = {
                            enabled = "always"
                        },
                        suggest = {
                            completeFunctionCalls = false,
                            autoImports = true,
                            includeCompletionsForModuleExports = false,
                            includeCompletionsWithSnippetText = false,
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
                            autoImportFileExcludePatterns = {
                                "node_modules/.cache/**",
                                "**/dist/**",
                                "**/.next/**",
                                "**/.turbo/**",
                                "**/build/**",
                                "**/coverage/**"
                            }
                        },
                        tsserver = {
                            maxTsServerMemory = 8192
                        }
                    },
                    javascript = {
                        updateImportsOnFileMove = {
                            enabled = "always"
                        },
                        suggest = {
                            completeFunctionCalls = false,
                            autoImports = true,
                            includeCompletionsForModuleExports = false,
                            includeCompletionsWithSnippetText = false,
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
                            autoImportFileExcludePatterns = {
                                "node_modules/.cache/**",
                                "**/dist/**",
                                "**/.next/**",
                                "**/.turbo/**",
                                "**/build/**",
                                "**/coverage/**"
                            }
                        },
                        tsserver = {
                            maxTsServerMemory = 8192
                        }
                    },
                    vtsls = {
                        enableMoveToFileCodeAction = true,
                        autoUseWorkspaceTsdk = true,
                        experimental = {
                            completion = {
                                enableServerSideFuzzyMatch = true,
                                entriesLimit = 100
                            }
                        },
                        tsserver = {
                            globalPlugins = {}
                        }
                    }
                },
                -- Make vtsls aware of monorepo project references
                root_markers = {"tsconfig.json", "jsconfig.json", "package.json", "turbo.json", ".git"}
            },

            -- Emmet completions for JSX/TSX (like VS Code built-in)
            emmet_language_server = {
                cmd = (vim.fn.executable("emmet-language-server") == 1) and { "emmet-language-server", "--stdio" }
                    or (vim.fn.filereadable(vim.fn.stdpath("data") .. "/mason/packages/emmet-language-server/node_modules/@olrtg/emmet-language-server/dist/index.js") == 1) and {
                        "node",
                        vim.fn.stdpath("data")
                            .. "/mason/packages/emmet-language-server/node_modules/@olrtg/emmet-language-server/dist/index.js",
                        "--stdio",
                    } or nil,
                filetypes = {"html", "css", "scss", "javascriptreact", "typescriptreact", "svelte", "vue"}
            },

            html = {
                cmd = (vim.fn.executable("vscode-html-language-server") == 1)
                        and { "vscode-html-language-server", "--stdio" }
                    or (vim.fn.filereadable(vim.fn.stdpath("data") .. "/mason/packages/html-lsp/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server") == 1) and {
                        "node",
                        vim.fn.stdpath("data")
                            .. "/mason/packages/html-lsp/node_modules/vscode-langservers-extracted/bin/vscode-html-language-server",
                        "--stdio",
                    } or nil,
            },

            -- Tailwind CSS IntelliSense (class suggestions like VS Code extension)
            tailwindcss = {
                cmd = (vim.fn.executable("tailwindcss-language-server") == 1) and { "tailwindcss-language-server", "--stdio" }
                    or (vim.fn.filereadable(vim.fn.stdpath("data") .. "/mason/packages/tailwindcss-language-server/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server") == 1) and {
                        "node",
                        vim.fn.stdpath("data")
                            .. "/mason/packages/tailwindcss-language-server/node_modules/@tailwindcss/language-server/bin/tailwindcss-language-server",
                        "--stdio",
                    } or nil,
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
            cssls = {
                cmd = (vim.fn.executable("vscode-css-language-server") == 1)
                        and { "vscode-css-language-server", "--stdio" }
                    or (vim.fn.filereadable(vim.fn.stdpath("data") .. "/mason/packages/css-lsp/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server") == 1) and {
                        "node",
                        vim.fn.stdpath("data")
                            .. "/mason/packages/css-lsp/node_modules/vscode-langservers-extracted/bin/vscode-css-language-server",
                        "--stdio",
                    } or nil,
            },

            -- JSON schemas: turbo.json, tsconfig, package.json etc.
            jsonls = {
                before_init = function(_, new_config)
                    local ok, schemastore = pcall(require, "schemastore")
                    if not ok or not schemastore then
                        return
                    end
                    new_config.settings = new_config.settings or {}
                    new_config.settings.json = new_config.settings.json or {}
                    new_config.settings.json.schemas = new_config.settings.json.schemas or {}
                    local ok_schemas, schemas = pcall(function()
                        return schemastore.json.schemas({
                            extra = {{
                                name = "turbo.json",
                                fileMatch = {"turbo.json"},
                                url = "https://turbo.build/schema.json"
                            }}
                        })
                    end)
                    if ok_schemas and type(schemas) == "table" then
                        vim.list_extend(new_config.settings.json.schemas, schemas)
                    end
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
{"rafamadriz/friendly-snippets"}}
