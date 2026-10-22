local language_settings = {
    updateImportsOnFileMove = {
        enabled = "always",
    },
    suggest = {
        completeFunctionCalls = false,
        autoImports = true,
        includeCompletionsForModuleExports = false,
        includeCompletionsWithSnippetText = false,
        classMemberSnippets = {
            enabled = false,
        },
        objectLiteralMethodSnippets = {
            enabled = false,
        },
    },
    inlayHints = {
        parameterNames = {
            enabled = "none",
        },
        parameterTypes = {
            enabled = false,
        },
        variableTypes = {
            enabled = false,
        },
        propertyDeclarationTypes = {
            enabled = false,
        },
        functionLikeReturnTypes = {
            enabled = false,
        },
        enumMemberValues = {
            enabled = false,
        },
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
            "**/coverage/**",
        },
    },
}

return { -- Use vtsls (wraps VS Code's TypeScript extension) for identical suggestions
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                -- Disable ts_ls in favor of vtsls
                ts_ls = {
                    enabled = false,
                },

                -- Disable emmet_ls in favor of emmet_language_server
                emmet_ls = {
                    enabled = false,
                },

                -- vtsls: VS Code's TypeScript language service for Neovim (optimized for zero typing lag)
                vtsls = {
                    settings = {
                        typescript = vim.tbl_deep_extend("force", vim.deepcopy(language_settings), {
                            tsserver = { maxTsServerMemory = 8192 },
                        }),
                        javascript = vim.deepcopy(language_settings),
                        vtsls = {
                            enableMoveToFileCodeAction = true,
                            autoUseWorkspaceTsdk = true,
                            experimental = {
                                completion = {
                                    enableServerSideFuzzyMatch = true,
                                    entriesLimit = 100,
                                },
                            },
                            tsserver = {
                                globalPlugins = {},
                            },
                        },
                    },
                    -- Make vtsls aware of monorepo project references
                    root_markers = { "tsconfig.json", "jsconfig.json", "package.json", "turbo.json", ".git" },
                },

                -- Emmet completions for JSX/TSX (like VS Code built-in)
                emmet_language_server = {
                    filetypes = { "html", "css", "scss", "javascriptreact", "typescriptreact", "svelte", "vue" },
                },

                html = {},

                -- Tailwind CSS IntelliSense (class suggestions like VS Code extension)
                tailwindcss = {
                    filetypes = {
                        "html",
                        "css",
                        "scss",
                        "javascript",
                        "javascriptreact",
                        "typescript",
                        "typescriptreact",
                        "svelte",
                        "vue",
                    },
                    settings = {
                        tailwindCSS = {
                            experimental = {
                                classRegex = {
                                    { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
                                    { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                                    { "cn\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                                    { "clsx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
                                },
                            },
                            validate = true,
                        },
                    },
                },

                -- CSS hover info and completions
                cssls = {},

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
                                extra = {
                                    {
                                        name = "turbo.json",
                                        fileMatch = { "turbo.json" },
                                        url = "https://turbo.build/schema.json",
                                    },
                                },
                            })
                        end)
                        if ok_schemas and type(schemas) == "table" then
                            vim.list_extend(new_config.settings.json.schemas, schemas)
                        end
                    end,
                    settings = {
                        json = {
                            validate = {
                                enable = true,
                            },
                        },
                    },
                },
            },
        },
    }, -- SchemaStore: catalog of JSON/YAML schemas (package.json, tsconfig, etc.)
    {
        "b0o/schemastore.nvim",
        lazy = true,
    }, -- Formatting with Prettier (like VS Code default formatter)
    {
        "stevearc/conform.nvim",
        optional = true,
        opts = {
            formatters_by_ft = {
                javascript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                javascriptreact = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                typescript = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                typescriptreact = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                json = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                jsonc = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                html = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                css = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                scss = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                markdown = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
                yaml = {
                    "prettierd",
                    "prettier",
                    stop_after_first = true,
                },
            },
        },
    }, -- Blink is the sole owner of automatic signature requests.
    {
        "folke/noice.nvim",
        opts = { lsp = { signature = { auto_open = { enabled = false } } } },
    }, -- Clean, non-intrusive completion engine (blink.cmp)
    {
        "saghen/blink.cmp",
        opts = {
            keymap = {
                preset = "super-tab",
                ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-y>"] = { "select_and_accept", "fallback" },
                ["<C-space>"] = { "show_documentation", "hide_documentation", "fallback" },
                ["<C-d>"] = { "show_documentation", "hide_documentation", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },
                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
            },
            completion = {
                accept = {
                    auto_brackets = {
                        enabled = true,
                    },
                },
                keyword = {
                    range = "full",
                },
                trigger = {
                    show_on_keyword = true,
                    show_on_trigger_character = true,
                    show_on_insert_on_trigger_character = true,
                    show_on_accept_on_trigger_character = true,
                },
                list = {
                    selection = {
                        preselect = true,
                        auto_insert = false,
                    },
                },
                -- Clean, rounded completion menu with max height limit
                menu = {
                    auto_show = true,
                    border = "rounded",
                    max_height = 10,
                    draw = {
                        columns = {
                            { "kind_icon" },
                            {
                                "label",
                                "label_description",
                                gap = 1,
                            },
                            { "source_name" },
                        },
                    },
                },
                -- Don't auto-popup huge documentation box on every single keypress
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 500,
                    window = {
                        border = "rounded",
                    },
                },
                -- Disable ghost text (inline grey preview text in front of cursor)
                ghost_text = {
                    enabled = false,
                },
            },
            -- Disable automatic function signature popup when typing functions like push_back(
            signature = {
                enabled = true,
                trigger = { enabled = false },
                window = {
                    border = "rounded",
                },
            },
            sources = {
                default = { "lsp", "path", "snippets", "buffer" },
                providers = {
                    lsp = {
                        async = true,
                        score_offset = 100,
                    },
                    path = {
                        score_offset = 80,
                    },
                    snippets = {
                        score_offset = 70,
                    },
                    buffer = {
                        score_offset = 50,
                        min_keyword_length = 3,
                    },
                },
            },
        },
    }, -- Snippets: friendly-snippets gives VS Code-like snippet library
    { "rafamadriz/friendly-snippets" },
}
