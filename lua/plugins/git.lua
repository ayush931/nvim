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
                vim.api.nvim_set_hl(0, "GitSignsAdd", {fg = "#34D399", bg = "NONE"})
                vim.api.nvim_set_hl(0, "GitSignsChange", {fg = "#38BDF8", bg = "NONE"})
                vim.api.nvim_set_hl(0, "GitSignsDelete", {fg = "#F43F5E", bg = "NONE"})
                vim.api.nvim_set_hl(0, "GitSignsChangeDelete", {fg = "#A855F7", bg = "NONE"})
                vim.api.nvim_set_hl(0, "GitSignsUntracked", {fg = "#64748B", bg = "NONE"})
                vim.api.nvim_set_hl(0, "SignColumn", {bg = "NONE"})
            end

            set_git_sign_highlights()
            vim.api.nvim_create_autocmd("ColorScheme", {
                callback = set_git_sign_highlights
            })
        end,
        opts = {
            signs = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "│" },
                untracked    = { text = "┆" },
            },
            signs_staged = {
                add          = { text = "▎" },
                change       = { text = "▎" },
                delete       = { text = "_" },
                topdelete    = { text = "‾" },
                changedelete = { text = "│" },
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
