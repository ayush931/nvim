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
        init = function()
            local function set_git_sign_highlights()
                vim.api.nvim_set_hl(0, "GitSignsAdd", {fg = "#7ee787", bg = "NONE", bold = true})
                vim.api.nvim_set_hl(0, "GitSignsChange", {fg = "#79c0ff", bg = "NONE", bold = true})
                vim.api.nvim_set_hl(0, "GitSignsDelete", {fg = "#ff7b72", bg = "NONE", bold = true})
                vim.api.nvim_set_hl(0, "GitSignsChangeDelete", {fg = "#d2a8ff", bg = "NONE", bold = true})
                vim.api.nvim_set_hl(0, "SignColumn", {bg = "NONE"})
            end

            set_git_sign_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = set_git_sign_highlights
            })
        end,
        opts = {
            signs = {
                add = {hl = "GitSignsAdd", text = "+", numhl = "GitSignsAddNr"},
                change = {hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr"},
                delete = {hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr"},
                topdelete = {hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr"},
                changedelete = {hl = "GitSignsChangeDelete", text = "±", numhl = "GitSignsChangeNr"}
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
