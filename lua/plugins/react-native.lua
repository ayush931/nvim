return { -- Treesitter parsers for RN filetypes
{
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed,
            {"tsx", "typescript", "javascript", "json", "xml", "kotlin", "swift", "groovy" -- for android/build.gradle
            })
        return opts
    end
}, -- LSP: ESLint for RN linting (vtsls is configured in completion.lua)
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            eslint = {}
        }
    }
}, -- React Native commands via which-key
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>R",
            group = "react-native"
        }, {
            "<leader>Rs",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native start",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Start Metro"
        }, {
            "<leader>Ra",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native run-android",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Run Android"
        }, {
            "<leader>Ri",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native run-ios",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Run iOS"
        }, {
            "<leader>Rl",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native log-android",
                    direction = "horizontal",
                    close_on_exit = false,
                    size = 15
                }):toggle()
            end,
            desc = "Logcat (Android)"
        }, {
            "<leader>Rd",
            "<cmd>!adb shell input keyevent 82<cr>",
            desc = "Open Dev Menu (Android)"
        }, {
            "<leader>Rr",
            "<cmd>!adb shell input text 'RR'<cr>",
            desc = "Reload (Android)"
        }}
    }
}, -- Neotest for running Jest tests (common in RN projects)
{
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {"nvim-neotest/neotest-jest"},
    opts = {
        adapters = {
            ["neotest-jest"] = {
                jestCommand = "npx jest",
                env = {
                    CI = "true"
                },
                cwd = function()
                    return vim.fn.getcwd()
                end
            }
        }
    }
}}
