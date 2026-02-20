return { -- Core LSP enhancements: inlay hints, codelens, diagnostics
{
    "neovim/nvim-lspconfig",
    opts = {
        -- Enable inlay hints globally (Neovim 0.10+)
        inlay_hints = {
            enabled = true,
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
                source = true
            }
        }
    }
}, -- Dim unused variables/imports (like VS Code graying out)
{
    "zbirenbaum/neodim",
    event = "LspAttach",
    opts = {
        alpha = 0.60,
        blend_color = "#000000",
        hide = {
            underline = true,
            virtual_text = true,
            signs = true
        },
        regex = {"[uU]nused", "[nN]ever [rR]ead", "[nN]ot [rR]ead"},
        priority = 128,
        disable = {}
    }
}, -- Better LSP UI: rename, code actions, hover with nice borders
{
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {"nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons"},
    opts = {
        symbol_in_winbar = {
            enable = true
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
            keys = {
                edit = "<CR>"
            }
        },
        rename = {
            in_select = false
        },
        ui = {
            border = "rounded"
        }
    },
    keys = {{
        "gd",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition"
    }, {
        "gD",
        "<cmd>Lspsaga goto_definition<CR>",
        desc = "Goto Definition"
    }, {
        "gr",
        "<cmd>Lspsaga finder<CR>",
        desc = "Find References"
    }, {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        desc = "Hover Doc"
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
        "<cmd>Lspsaga show_line_diagnostics<CR>",
        desc = "Line Diagnostics"
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
