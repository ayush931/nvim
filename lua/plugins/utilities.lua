-- ╔══════════════════════════════════════════════════════════════╗
-- ║                    Utility Plugins                         ║
-- ╚══════════════════════════════════════════════════════════════╝
return { -- ── Surround: add/change/delete surrounding pairs ──────────────
{
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    opts = {}
}, -- ── Auto-pairs: auto-close brackets, quotes, etc. ─────────────
{
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
        check_ts = true, -- use treesitter to check for a pair
        fast_wrap = {
            map = "<M-e>" -- Alt-e to fast-wrap
        }
    }
}, -- ── Undo Tree: visualize and navigate undo history ─────────────
{
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {{
        "<leader>cu",
        "<cmd>UndotreeToggle<cr>",
        desc = "Toggle Undo Tree"
    }}
},

-- ── Better quickfix window ─────────────────────────────────────
{
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    opts = {
        auto_resize_height = true,
        preview = {
            winblend = 0
        }
    }
},
 -- ── Comment box: create pretty comment headers ─────────────────
{
    "LudoPinelli/comment-box.nvim",
    event = "VeryLazy",
    keys = {{
        "<leader>cb",
        "<cmd>CBccbox<cr>",
        mode = {"n", "v"},
        desc = "Comment Box (centered)"
    }, {
        "<leader>cl",
        "<cmd>CBccline<cr>",
        mode = {"n", "v"},
        desc = "Comment Line (centered)"
    }},
    opts = {}
}}
