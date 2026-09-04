return { -- Core LSP enhancements: inlay hints, codelens, diagnostics
{
    "neovim/nvim-lspconfig",
    opts = {
        -- Enable inlay hints globally (Neovim 0.10+)
        inlay_hints = {
            enabled = false,
            exclude = {"markdown", "text", "gitcommit"}
        },

        -- Enable codelens (reference counts, run/debug actions, etc.)
        codelens = {
            enabled = true
        },

        -- Better diagnostic display
        diagnostics = {
            underline = true,
            update_in_insert = false,
            virtual_text = {
                spacing = 4,
                source = "if_many",
                prefix = "●"
            },
            severity_sort = true,
            float = {
                focusable = true,
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
                max_width = 120,
                max_height = 30,
                wrap = true,
                close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
            }
        }
    }
}, -- Better LSP UI: rename, code actions, hover with nice borders
{
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"},
    opts = {
        symbol_in_winbar = {
            enable = false
        },
        lightbulb = {
            enable = false
        },
        finder = {
            keys = {
                toggle_or_open = "<CR>"
            }
        },
        definition = {
            width = 0.85,
            height = 0.65,
            keys = {
                edit = "<CR>",
                vsplit = "<C-v>",
                split = "<C-x>",
                tabe = "<C-t>",
                quit = "q",
                close = "<Esc>",
            }
        },
        rename = {
            in_select = false
        },
        diagnostic = {
            max_width = 0.9,
            max_height = 0.8,
            wrap_line = true,
            show_code_action = true,
            show_source = true,
            jump_num_shortcut = true,
        },
        hover = {
            max_width = 0.9,
            max_height = 0.8,
            open_link = "gx",
        },
        ui = {
            border = "rounded"
        }
    },
    keys = {{
        "gd",
        "<cmd>Lspsaga goto_definition<CR>",
        desc = "Goto Definition"
    }, {
        "gD",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition"
    }, {
        "gp",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition"
    }, {
        "gy",
        "<cmd>Lspsaga peek_type_definition<CR>",
        desc = "Type Definition"
    }, {
        "gi",
        function() vim.lsp.buf.implementation() end,
        desc = "Goto Implementation"
    }, {
        "gr",
        "<cmd>Lspsaga finder<CR>",
        desc = "Find References"
    }, {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        desc = "Hover Definition / Doc"
    }, {
        "gs",
        "<cmd>Lspsaga signature_help<CR>",
        desc = "Signature Help"
    }, {
        "<C-k>",
        "<cmd>Lspsaga signature_help<CR>",
        desc = "Signature Help",
        mode = "i"
    }, {
        "<leader>cd",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition"
    }, {
        "<leader>ca",
        "<cmd>Lspsaga code_action<CR>",
        desc = "Code Action",
        mode = {"n", "v"}
    }, {
        "<leader>cr",
        "<cmd>Lspsaga rename<CR>",
        desc = "Rename Symbol"
    }, {
        "<leader>cD",
        "<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>",
        desc = "Line Diagnostics (Full Error & Suggestions)"
    }, {
        "gl",
        "<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>",
        desc = "Show Line Diagnostics & Suggestions"
    }, {
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        desc = "Prev Diagnostic"
    }, {
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        desc = "Next Diagnostic"
    }, {
        "<leader>co",
        "<cmd>Lspsaga outline<CR>",
        desc = "Symbol Outline"
    }}
}, -- Incremental LSP rename with live preview
{
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    opts = {},
    keys = {{
        "<leader>cR",
        function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Inc Rename (preview)"
    }}
}, -- Navic: breadcrumb navigation showing current code context
{
    "SmiteshP/nvim-navic",
    lazy = true,
    init = function()
        vim.g.navic_silence = true
        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local client = vim.lsp.get_client_by_id(args.data.client_id)
                if client and client.supports_method("textDocument/documentSymbol") then
                    require("nvim-navic").attach(client, args.buf)
                end
            end
        })
    end,
    opts = {
        separator = " › ",
        depth_limit = 5,
        lazy_update_context = true
    }
}}
