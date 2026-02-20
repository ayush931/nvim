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
}}
