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
}, -- Required stub: mini.pairs is a LazyVim core plugin (nvim-autopairs above
-- is the active pair engine). This entry installs nothing; it keeps the core
-- plugin disabled. Deleting it would re-enable LazyVim's default mini.pairs.
{
    "nvim-mini/mini.pairs",
    enabled = false
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
}}
