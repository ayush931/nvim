-- ╔══════════════════════════════════════════════════════════════╗
-- ║                   Navigation Plugins                       ║
-- ╚══════════════════════════════════════════════════════════════╝
return
    { -- ── Flash: lightning-fast cursor movement ──────────────────────
    {
        "folke/flash.nvim",
        event = "VeryLazy",
        opts = {
            modes = {
                search = {
                    enabled = true
                }, -- integrate with / search
                char = {
                    enabled = true
                } -- enhance f, F, t, T
            },
            label = {
                rainbow = {
                    enabled = true
                }
            }
        },
        -- stylua: ignore
        keys = {{
            "s",
            mode = {"n", "x", "o"},
            function()
                require("flash").jump()
            end,
            desc = "Flash"
        }, {
            "S",
            mode = {"n", "x", "o"},
            function()
                require("flash").treesitter()
            end,
            desc = "Flash Treesitter"
        }, {
            "r",
            mode = "o",
            function()
                require("flash").remote()
            end,
            desc = "Remote Flash"
        }, {
            "R",
            mode = {"o", "x"},
            function()
                require("flash").treesitter_search()
            end,
            desc = "Treesitter Search"
        }, {
            "<c-s>",
            mode = {"c"},
            function()
                require("flash").toggle()
            end,
            desc = "Toggle Flash Search"
        }}
    }, -- ── Harpoon: bookmark and jump to key files instantly ──────────
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {"nvim-lua/plenary.nvim"},
        keys = {{
            "<leader>ha",
            function()
                require("harpoon"):list():add()
                vim.notify("Harpooned!", vim.log.levels.INFO)
            end,
            desc = "Harpoon Add File"
        }, {
            "<leader>hh",
            function()
                local harpoon = require("harpoon")
                harpoon.ui:toggle_quick_menu(harpoon:list())
            end,
            desc = "Harpoon Menu"
        }, {
            "<leader>h1",
            function()
                require("harpoon"):list():select(1)
            end,
            desc = "Harpoon File 1"
        }, {
            "<leader>h2",
            function()
                require("harpoon"):list():select(2)
            end,
            desc = "Harpoon File 2"
        }, {
            "<leader>h3",
            function()
                require("harpoon"):list():select(3)
            end,
            desc = "Harpoon File 3"
        }, {
            "<leader>h4",
            function()
                require("harpoon"):list():select(4)
            end,
            desc = "Harpoon File 4"
        }, {
            "<leader>hp",
            function()
                require("harpoon"):list():prev()
            end,
            desc = "Harpoon Prev"
        }, {
            "<leader>hn",
            function()
                require("harpoon"):list():next()
            end,
            desc = "Harpoon Next"
        }},
        opts = {}
    }, -- ── Window picker: quickly pick a window to jump to ────────────
    {
        "s1n7ax/nvim-window-picker",
        version = "2.*",
        event = "VeryLazy",
        keys = {{
            "<leader>wp",
            function()
                local win = require("window-picker").pick_window()
                if win then
                    vim.api.nvim_set_current_win(win)
                end
            end,
            desc = "Pick Window"
        }},
        opts = {
            hint = "floating-big-letter",
            filter_rules = {
                bo = {
                    filetype = {"neo-tree", "neo-tree-popup", "notify"},
                    buftype = {"terminal", "quickfix"}
                }
            }
        }
    }, -- ── Oil.nvim: edit filesystem like a buffer ────────────────────
    {
        "stevearc/oil.nvim",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        cmd = "Oil",
        keys = {{
            "-",
            "<cmd>Oil<cr>",
            desc = "Open Parent Directory (Oil)"
        }},
        opts = {
            view_options = {
                show_hidden = true
            },
            float = {
                padding = 4,
                max_width = 120,
                max_height = 40
            },
            keymaps = {
                ["q"] = "actions.close",
                ["<C-s>"] = "actions.save"
            }
        }
    }}
