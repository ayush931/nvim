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
                map("n", "]h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]c", bang = true })
                    else
                        gs.nav_hunk("next")
                    end
                end, { desc = "Next Hunk" })
                map("n", "[h", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[c", bang = true })
                    else
                        gs.nav_hunk("prev")
                    end
                end, { desc = "Prev Hunk" })
                map("n", "]H", function() gs.nav_hunk("last") end, { desc = "Last Hunk" })
                map("n", "[H", function() gs.nav_hunk("first") end, { desc = "First Hunk" })
                map({"n", "x"}, "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "Stage Hunk" })
                map({"n", "x"}, "<leader>ghr", ":Gitsigns reset_hunk<CR>", { desc = "Reset Hunk" })
                map("n", "<leader>ghS", gs.stage_buffer, { desc = "Stage Buffer" })
                map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
                map("n", "<leader>ghR", gs.reset_buffer, { desc = "Reset Buffer" })
                map("n", "<leader>ghp", gs.preview_hunk_inline, { desc = "Preview Hunk Inline" })
                map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, { desc = "Blame Line" })
                map("n", "<leader>ghB", gs.blame, { desc = "Blame Buffer" })
                map("n", "<leader>ghd", gs.diffthis, { desc = "Diff This" })
                map("n", "<leader>ghD", function() gs.diffthis("~") end, { desc = "Diff This ~" })
                map({"o", "x"}, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select Hunk" })
                map('n', '<leader>gb', gs.blame_line, { desc = "Git Blame Line" })
                map('n', '<leader>gp', gs.preview_hunk, { desc = "Preview Hunk" })
                map('n', '<leader>gr', gs.reset_hunk, { desc = "Reset Hunk" })
                map('n', '<leader>gs', gs.stage_hunk, { desc = "Stage Hunk" })
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
