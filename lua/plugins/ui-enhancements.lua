-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   UI Enhancement Plugins                   ║
-- ╚══════════════════════════════════════════════════════════════╝
return
    { -- ── Indent Blankline: show indent guides ───────────────────────
    {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        event = {"BufReadPost", "BufNewFile"},
        opts = {
            indent = {
                char = "│",
                tab_char = "│"
            },
            scope = {
                show_start = false,
                show_end = false
            },
            exclude = {
                filetypes = {"help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble", "lazy", "mason", "notify",
                             "toggleterm", "lazyterm"}
            }
        }
    },

    -- ── Colorful window separators ─────────────────────────────────
    {
        "nvim-zh/colorful-winsep.nvim",
        event = "WinNew",
        opts = {
            hi = {
                fg = "#89b4fa" -- catppuccin blue, change to match your colorscheme
            }
        }
    }, -- ── Dressing: better vim.ui.select and vim.ui.input ────────────
    {
        "stevearc/dressing.nvim",
        event = "VeryLazy",
        opts = {
            input = {
                default_prompt = "➤ ",
                win_options = {
                    winblend = 0
                }
            },
            select = {
                backend = {"telescope", "builtin"}
            }
        }
    }, -- ── Nvim-UFO: modern folding with LSP/Treesitter ──────────────
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {"kevinhwang91/promise-async"},
        event = "BufReadPost",
        init = function()
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
        end,
        keys = {{
            "zR",
            function()
                require("ufo").openAllFolds()
            end,
            desc = "Open All Folds"
        }, {
            "zM",
            function()
                require("ufo").closeAllFolds()
            end,
            desc = "Close All Folds"
        }, {
            "zK",
            function()
                local winid = require("ufo").peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
            desc = "Peek Fold / Hover"
        }},
        opts = {
            provider_selector = function()
                return {"treesitter", "indent"}
            end
        }
    }, -- ── Noice: better cmdline, messages, and popupmenu ─────────────
    {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"},
        opts = {
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true
                }
            },
            presets = {
                bottom_search = true,
                command_palette = true,
                long_message_to_split = true,
                lsp_doc_border = true
            }
        }
    }, -- ── Nvim-Notify: fancy notification popups ─────────────────────
    {
        "rcarriga/nvim-notify",
        event = "VeryLazy",
        keys = {{
            "<leader>un",
            function()
                require("notify").dismiss({
                    silent = true,
                    pending = true
                })
            end,
            desc = "Dismiss All Notifications"
        }},
        opts = {
            stages = "fade_in_slide_out",
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
            on_open = function(win)
                vim.api.nvim_win_set_config(win, {
                    zindex = 100
                })
            end,
            render = "wrapped-compact"
        }
    }, -- ── Fidget: LSP progress indicator in the corner ───────────────
    {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            progress = {
                display = {
                    done_ttl = 3,
                    progress_icon = {
                        pattern = "dots"
                    }
                }
            },
            notification = {
                window = {
                    winblend = 0
                }
            }
        }
    }, -- ── Hlchunk: highlight the current chunk/scope ─────────────────
    {
        "shellRaining/hlchunk.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            chunk = {
                enable = true,
                style = {{
                    fg = "#89b4fa"
                } -- color of the chunk marker
                },
                delay = 100
            },
            indent = {
                enable = false -- using indent-blankline instead
            },
            line_num = {
                enable = true,
                style = "#89b4fa"
            }
        }
    }}
