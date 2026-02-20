return { -- Neotest: unified test runner UI (run/debug tests like VS Code Testing panel)
{
    "nvim-neotest/neotest",
    dependencies = {"nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim",
                    "nvim-treesitter/nvim-treesitter", -- Test adapters
    "nvim-neotest/neotest-jest", "marilari88/neotest-vitest", "nvim-neotest/neotest-python"},
    keys = {{
        "<leader>tn",
        function()
            require("neotest").run.run()
        end,
        desc = "Run Nearest Test"
    }, {
        "<leader>tF",
        function()
            require("neotest").run.run(vim.fn.expand("%"))
        end,
        desc = "Run File Tests"
    }, {
        "<leader>tS",
        function()
            require("neotest").run.run({
                suite = true
            })
        end,
        desc = "Run Test Suite"
    }, {
        "<leader>tl",
        function()
            require("neotest").run.run_last()
        end,
        desc = "Re-run Last Test"
    }, {
        "<leader>ts",
        function()
            require("neotest").summary.toggle()
        end,
        desc = "Toggle Test Summary"
    }, {
        "<leader>to",
        function()
            require("neotest").output.open({
                enter = true,
                auto_close = true
            })
        end,
        desc = "Show Test Output"
    }, {
        "<leader>tO",
        function()
            require("neotest").output_panel.toggle()
        end,
        desc = "Toggle Output Panel"
    }, {
        "<leader>tw",
        function()
            require("neotest").watch.toggle(vim.fn.expand("%"))
        end,
        desc = "Watch File Tests"
    }, {
        "<leader>td",
        function()
            require("neotest").run.run({
                strategy = "dap"
            })
        end,
        desc = "Debug Nearest Test"
    }, {
        "<leader>tD",
        function()
            require("neotest").run.run({
                vim.fn.expand("%"),
                strategy = "dap"
            })
        end,
        desc = "Debug File Tests"
    }, {
        "[t",
        function()
            require("neotest").jump.prev({
                status = "failed"
            })
        end,
        desc = "Prev Failed Test"
    }, {
        "]t",
        function()
            require("neotest").jump.next({
                status = "failed"
            })
        end,
        desc = "Next Failed Test"
    }},
    opts = function()
        local adapters = {require("neotest-vitest")({
            filter_dir = function(name)
                return name ~= "node_modules"
            end,
            vitestCommand = "npx vitest"
        }), require("neotest-jest")({
            jestCommand = "npx jest",
            jestConfigFile = function(file)
                local root = require("neotest-jest.util").find_package_json_ancestor(file)
                if root then
                    local config = root .. "/jest.config.ts"
                    if vim.fn.filereadable(config) == 1 then
                        return config
                    end
                    config = root .. "/jest.config.js"
                    if vim.fn.filereadable(config) == 1 then
                        return config
                    end
                end
                return vim.fn.getcwd() .. "/jest.config.ts"
            end,
            env = {
                CI = "true"
            },
            cwd = function(file)
                return require("neotest-jest.util").find_package_json_ancestor(file) or vim.fn.getcwd()
            end
        })}

        local has_python, neotest_python = pcall(require, "neotest-python")
        if has_python then
            table.insert(adapters, neotest_python({
                dap = {
                    justMyCode = false
                },
                runner = "pytest"
            }))
        end

        return {
            adapters = adapters,
            -- Status icons in the gutter (like VS Code green/red dots)
            status = {
                enabled = true,
                signs = true,
                virtual_text = true
            },
            -- Inline diagnostics for failed tests
            diagnostic = {
                enabled = true,
                severity = vim.diagnostic.severity.ERROR
            },
            -- Floating output window
            output = {
                enabled = true,
                open_on_run = false
            },
            -- Summary panel on the right
            summary = {
                enabled = true,
                animated = true,
                follow = true,
                expand_errors = true,
                mappings = {
                    expand = {"<CR>", "<2-LeftMouse>"},
                    expand_all = "e",
                    jumpto = "i",
                    output = "o",
                    run = "r",
                    short = "O",
                    stop = "u",
                    watch = "w"
                }
            },
            -- Watch mode
            watch = {
                enabled = true
            },
            -- Quickfix integration
            quickfix = {
                enabled = true,
                open = false
            }
        }
    end
}, -- Which-key group label for test keymaps
{
    "folke/which-key.nvim",
    opts = {
        spec = {{
            "<leader>t",
            group = "test/turbo"
        }}
    }
}}
