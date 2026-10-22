-- LSP mappings belong here so buffer-local defaults cannot shadow them.
local lsp_keys = {
    {
        "gd",
        "<cmd>Lspsaga goto_definition<CR>",
        desc = "Goto Definition",
    },
    {
        "gD",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition",
    },
    {
        "gp",
        "<cmd>Lspsaga peek_definition<CR>",
        desc = "Peek Definition",
    },
    {
        "gy",
        "<cmd>Lspsaga peek_type_definition<CR>",
        desc = "Type Definition",
    },
    {
        "gi",
        function()
            vim.lsp.buf.implementation()
        end,
        desc = "Goto Implementation",
    },
    {
        "gr",
        "<cmd>Lspsaga finder<CR>",
        desc = "Find References",
    },
    {
        "K",
        "<cmd>Lspsaga hover_doc<CR>",
        desc = "Hover Definition / Doc",
    },
    {
        "gs",
        function()
            vim.lsp.buf.signature_help({ border = "rounded" })
        end,
        desc = "Signature Help",
    },
    {
        "<C-k>",
        function()
            vim.lsp.buf.signature_help({ border = "rounded" })
        end,
        desc = "Signature Help",
        mode = "i",
    },
    {
        "<leader>ca",
        "<cmd>Lspsaga code_action<CR>",
        desc = "Code Action",
        mode = { "n", "x" },
    },
    {
        "<leader>cr",
        "<cmd>Lspsaga rename<CR>",
        desc = "Rename Symbol",
    },
    {
        "<leader>cD",
        "<cmd>Lspsaga show_buf_diagnostics<CR>",
        desc = "Buffer Diagnostics Box",
    },
    {
        "gl",
        "<cmd>Lspsaga show_line_diagnostics ++unfocus<CR>",
        desc = "Peek Line Diagnostics (Box)",
    },
    {
        "[d",
        "<cmd>Lspsaga diagnostic_jump_prev<CR>",
        desc = "Prev Diagnostic",
    },
    {
        "]d",
        "<cmd>Lspsaga diagnostic_jump_next<CR>",
        desc = "Next Diagnostic",
        -- NOTE: symbol outline lives once in aerial.nvim (<leader>cs / <leader>cS);
        -- removed a duplicate Lspsaga outline keymap here.
    },

    {
        "<leader>cR",
        function()
            return ":IncRename " .. vim.fn.expand("<cword>")
        end,
        expr = true,
        desc = "Inc Rename (preview)",
    },
}

return { -- Core LSP enhancements: inlay hints, codelens, diagnostics
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = { ["*"] = { keys = lsp_keys } },
            -- Keep inlay hints opt-in with <leader>uh.
            inlay_hints = {
                enabled = false,
                exclude = { "markdown", "text", "gitcommit" },
            },

            -- Refresh code lenses manually with <leader>cC to avoid background polling.
            codelens = {
                enabled = false,
            },

            -- Better diagnostic display
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = false, -- Only show inside the box, hide default inline text
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
                    -- No CursorMoved: the box must stay open while reading and
                    -- yanking its text (it still closes on leave / typing / focus loss,
                    -- or manually with q / <Esc>).
                    close_events = { "BufLeave", "InsertEnter", "FocusLost" },
                },
            },
        },
    }, -- Better LSP UI: rename, code actions, hover with nice borders
    {
        "nvimdev/lspsaga.nvim",
        event = "LspAttach",
        dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
        opts = {
            symbol_in_winbar = {
                enable = false,
            },
            lightbulb = {
                enable = false,
            },
            finder = { keys = { toggle_or_open = "<CR>" } },
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
                },
            },
            rename = { in_select = false },
            diagnostic = {
                max_width = 0.9,
                max_height = 0.8,
                max_show_width = 0.9,
                max_show_height = 0.8,
                wrap_long_lines = true,
                wrap_line = true,
                show_code_action = true,
                show_source = true,
                jump_num_shortcut = true,
            },
            hover = { max_width = 0.9, max_height = 0.8, open_link = "gx" },
            ui = { border = "rounded" },
        },
    },
    { "smjonas/inc-rename.nvim", cmd = "IncRename", opts = {} },
}
