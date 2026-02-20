-- ╔══════════════════════════════════════════════════════════════╗
-- ║                  Productivity Plugins                      ║
-- ╚══════════════════════════════════════════════════════════════╝
return
    { -- ── Zen Mode: distraction-free coding ──────────────────────────
    {
        "folke/zen-mode.nvim",
        cmd = "ZenMode",
        keys = {{
            "<leader>uz",
            "<cmd>ZenMode<cr>",
            desc = "Toggle Zen Mode"
        }},
        opts = {
            window = {
                width = 120,
                options = {
                    signcolumn = "no",
                    number = false,
                    relativenumber = false,
                    cursorline = false
                }
            },
            plugins = {
                twilight = {
                    enabled = true
                },
                gitsigns = {
                    enabled = false
                },
                tmux = {
                    enabled = true
                }
            }
        }
    },

    -- ── Twilight: dim inactive code blocks ─────────────────────────
    {
        "folke/twilight.nvim",
        cmd = {"Twilight", "TwilightEnable", "TwilightDisable"},
        keys = {{
            "<leader>ut",
            "<cmd>Twilight<cr>",
            desc = "Toggle Twilight"
        }},
        opts = {
            dimming = {
                alpha = 0.35
            },
            context = 15,
            treesitter = true
        }
    }, -- ── Spectre: project-wide search & replace ─────────────────────
    {
        "nvim-pack/nvim-spectre",
        dependencies = {"nvim-lua/plenary.nvim"},
        cmd = "Spectre",
        keys = {{
            "<leader>sr",
            function()
                require("spectre").open()
            end,
            desc = "Replace in Files (Spectre)"
        }, {
            "<leader>sw",
            function()
                require("spectre").open_visual({
                    select_word = true
                })
            end,
            desc = "Search Current Word (Spectre)"
        }, {
            "<leader>sf",
            function()
                require("spectre").open_file_search({
                    select_word = true
                })
            end,
            desc = "Search in Current File (Spectre)"
        }},
        opts = {
            open_cmd = "noswapfile vnew"
        }
    }, -- ── Marks: better mark management and visualization ────────────
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {
            default_mappings = true,
            signs = true,
            mappings = {}
        }
    }, -- ── Mini.ai: better around/inside textobjects ─────────────────
    {
        "nvim-mini/mini.ai",
        version = "*",
        event = "VeryLazy",
        opts = function()
            local ai = require("mini.ai")
            return {
                n_lines = 500,
                custom_textobjects = {
                    -- whole buffer
                    e = function()
                        local from = {
                            line = 1,
                            col = 1
                        }
                        local to = {
                            line = vim.fn.line("$"),
                            col = math.max(vim.fn.getline("$"):len(), 1)
                        }
                        return {
                            from = from,
                            to = to
                        }
                    end,
                    -- function definition (treesitter)
                    f = ai.gen_spec.treesitter({
                        a = "@function.outer",
                        i = "@function.inner"
                    }),
                    -- class
                    c = ai.gen_spec.treesitter({
                        a = "@class.outer",
                        i = "@class.inner"
                    }),
                    -- block
                    b = ai.gen_spec.treesitter({
                        a = "@block.outer",
                        i = "@block.inner"
                    })
                }
            }
        end
    }, -- ── Mini.move: move lines and selections with Alt+hjkl ────────
    {
        "nvim-mini/mini.move",
        version = "*",
        event = "VeryLazy",
        opts = {
            mappings = {
                left = "<M-h>",
                right = "<M-l>",
                down = "<M-j>",
                up = "<M-k>",
                line_left = "<M-h>",
                line_right = "<M-l>",
                line_down = "<M-j>",
                line_up = "<M-k>"
            }
        }
    }, -- ── Yanky: improved yank and put with history ──────────────────
    {
        "gbprod/yanky.nvim",
        event = "VeryLazy",
        keys = {{
            "<leader>yh",
            function()
                require("telescope").extensions.yank_history.yank_history()
            end,
            desc = "Yank History"
        }, {
            "y",
            "<Plug>(YankyYank)",
            mode = {"n", "x"},
            desc = "Yank"
        }, {
            "p",
            "<Plug>(YankyPutAfter)",
            mode = {"n", "x"},
            desc = "Put After"
        }, {
            "P",
            "<Plug>(YankyPutBefore)",
            mode = {"n", "x"},
            desc = "Put Before"
        }, {
            "<c-p>",
            "<Plug>(YankyPreviousEntry)",
            desc = "Cycle Yank (prev)"
        }, {
            "<c-n>",
            "<Plug>(YankyNextEntry)",
            desc = "Cycle Yank (next)"
        }},
        opts = {
            ring = {
                history_length = 50
            },
            highlight = {
                timer = 250
            }
        }
    }}
