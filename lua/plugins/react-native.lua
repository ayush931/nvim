return { -- React Native DAP adapter (attach to Metro / Hermes)
{
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
        local dap = require("dap")
        local install_dir = require("mason.settings").current.install_root_dir

        dap.adapters["pwa-node"] = dap.adapters["pwa-node"] or {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
                command = "node",
                args = {install_dir .. "/packages/js-debug-adapter" .. "/js-debug/src/dapDebugServer.js", "${port}"}
            }
        }

        -- Attach to React Native running on Metro
        dap.configurations.typescriptreact = dap.configurations.typescriptreact or {}
        table.insert(dap.configurations.typescriptreact, {
            type = "pwa-node",
            request = "attach",
            name = "Attach to React Native (Metro)",
            port = 8081,
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            skipFiles = {"<node_internals>/**", "node_modules/**"}
        })
    end
}, -- Treesitter parsers for RN filetypes
{
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed,
            {"tsx", "typescript", "javascript", "json", "xml", "kotlin", "swift", "groovy" -- for android/build.gradle
            })
    end
}, -- LSP: ESLint for RN linting (vtsls is configured in completion.lua)
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            eslint = {}
        }
    }
}, -- Mason: install required tooling
{
    "mason-org/mason.nvim",
    opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, {"js-debug-adapter", "eslint-lsp"})
    end
}, -- React Native commands via which-key
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>r",
            group = "react-native"
        }, {
            "<leader>rs",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native start",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Start Metro"
        }, {
            "<leader>ra",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native run-android",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Run Android"
        }, {
            "<leader>ri",
            function()
                require("toggleterm.terminal").Terminal:new({
                    cmd = "npx react-native run-ios",
                    direction = "float",
                    close_on_exit = false
                }):toggle()
            end,
            desc = "Run iOS"
        }, {
            "<leader>rl",
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
            "<leader>rd",
            "<cmd>!adb shell input keyevent 82<cr>",
            desc = "Open Dev Menu (Android)"
        }, {
            "<leader>rr",
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
