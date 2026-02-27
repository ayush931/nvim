return { -- Side-by-side diff viewer and file history
{
    "sindrets/diffview.nvim",
    cmd = {"DiffviewOpen", "DiffviewFileHistory"},
    keys = {{
        "<leader>gd",
        "<cmd>DiffviewOpen<cr>",
        desc = "Diffview Open"
    }, {
        "<leader>gh",
        "<cmd>DiffviewFileHistory %<cr>",
        desc = "File History (current)"
    }, {
        "<leader>gH",
        "<cmd>DiffviewFileHistory<cr>",
        desc = "File History (repo)"
    }},
    opts = {
        enhanced_diff_hl = true,
        view = {
            default = {
                layout = "diff2_horizontal"
            }
        }
    }
}, -- Resolve git conflicts interactively
{

    "akinsho/git-conflict.nvim",
    version = "*",
    event = "BufReadPre",
    opts = {
        default_mappings = true,
        disable_diagnostics = true
    }
},

    -- Inline git signs and hunk actions
    {
        "lewis6991/gitsigns.nvim",
        event = {"BufReadPre", "BufNewFile"},
        opts = {
            signs = {
                add = {hl = "GitGutterAdd", text = "+", numhl = "GitSignsAddNr"},
                change = {hl = "GitGutterChange", text = "~", numhl = "GitSignsChangeNr"},
                delete = {hl = "GitGutterDelete", text = "_", numhl = "GitSignsDeleteNr"},
                topdelete = {hl = "GitGutterDelete", text = "‾", numhl = "GitSignsDeleteNr"},
                changedelete = {hl = "GitGutterChangeDelete", text = "~", numhl = "GitSignsChangeNr"}
            },
            current_line_blame = true,
            on_attach = function(bufnr)
                local gs = package.loaded.gitsigns
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end
                map('n', '<leader>gb', gs.blame_line, {desc = "Git Blame Line"})
                map('n', '<leader>gp', gs.preview_hunk, {desc = "Preview Hunk"})
                map('n', '<leader>gr', gs.reset_hunk, {desc = "Reset Hunk"})
                map('n', '<leader>gs', gs.stage_hunk, {desc = "Stage Hunk"})
            end
        }
    },

    -- Fugitive for advanced git commands
    {
        "tpope/vim-fugitive",
        cmd = {"Git", "G"},
        keys = {
            {"<leader>gg", ":Git<CR>", desc = "Fugitive Git Status"}
        }
    },

    -- Neogit for Magit-like UI
    {
        "NeogitOrg/neogit",
        cmd = "Neogit",
        dependencies = {"nvim-lua/plenary.nvim"},
        keys = {
            {"<leader>gn", ":Neogit<CR>", desc = "Neogit"}
        },
        opts = {
            integrations = {diffview = true}
        }
    }
}
