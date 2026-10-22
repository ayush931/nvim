return { -- Neotest: unified test runner UI (run/debug tests like VS Code Testing panel)
    {
        "nvim-neotest/neotest",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter", -- Test adapters
            "nvim-neotest/neotest-jest",
            "marilari88/neotest-vitest",
            "nvim-neotest/neotest-python",
            "nvim-neotest/neotest-go",
        },
        keys = {
            {
                "<leader>tn",
                function()
                    require("neotest").run.run()
                end,
                desc = "Run Nearest Test",
            },
            {
                "<leader>tF",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File Tests",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.run({
                        suite = true,
                    })
                end,
                desc = "Run Test Suite",
            },
            {
                "<leader>tl",
                function()
                    require("neotest").run.run_last()
                end,
                desc = "Re-run Last Test",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Test Summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({
                        enter = true,
                        auto_close = true,
                    })
                end,
                desc = "Show Test Output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle Output Panel",
            },
            {
                "<leader>tw",
                function()
                    require("neotest").watch.toggle(vim.fn.expand("%"))
                end,
                desc = "Watch File Tests",
            },
            {
                "<leader>td",
                function()
                    require("neotest").run.run({
                        strategy = "dap",
                    })
                end,
                desc = "Debug Nearest Test",
            },
            {
                "<leader>tD",
                function()
                    require("neotest").run.run({
                        vim.fn.expand("%"),
                        strategy = "dap",
                    })
                end,
                desc = "Debug File Tests",
            },
            {
                "[t",
                function()
                    require("neotest").jump.prev({
                        status = "failed",
                    })
                end,
                desc = "Prev Failed Test",
            },
            {
                "]t",
                function()
                    require("neotest").jump.next({
                        status = "failed",
                    })
                end,
                desc = "Next Failed Test",
            },
        },
        opts = function()
            local adapters = {
                require("neotest-vitest")({
                    filter_dir = function(name)
                        return name ~= "node_modules"
                    end,
                    vitestCommand = "npx --no-install vitest",
                }),
                require("neotest-jest")({
                    jestCommand = "npx --no-install jest",
                    jestConfigFile = function(file)
                        -- Resolve from the test file, including configs inherited from a
                        -- monorepo root; never fall back to an unrelated current buffer.
                        return vim.fs.find({
                            "jest.config.ts",
                            "jest.config.js",
                            "jest.config.cjs",
                            "jest.config.mjs",
                            "jest.config.cts",
                            "jest.config.mts",
                            "jest.config.json",
                        }, { path = vim.fs.dirname(file), upward = true, type = "file" })[1]
                    end,
                    env = {
                        CI = "true",
                    },
                    cwd = function(file)
                        return vim.fs.root(file, { "package.json" }) or require("config.project").root(file)
                    end,
                }),
            }

            local has_python, neotest_python = pcall(require, "neotest-python")
            if has_python then
                table.insert(
                    adapters,
                    neotest_python({
                        dap = {
                            justMyCode = false,
                        },
                        runner = "pytest",
                    })
                )
            end

            local has_go, neotest_go = pcall(require, "neotest-go")
            if has_go then
                table.insert(
                    adapters,
                    neotest_go({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s" },
                    })
                )
            end

            return {
                adapters = adapters,
                discovery = {
                    -- The default (0) allocates workers using every available CPU.
                    concurrent = 1,
                    filter_dir = function(name)
                        return not vim.tbl_contains({
                            ".git",
                            "node_modules",
                            ".next",
                            ".turbo",
                            "dist",
                            "build",
                            "coverage",
                            ".venv",
                            "venv",
                        }, name)
                    end,
                },
                -- Status icons in the gutter (like VS Code green/red dots)
                status = {
                    enabled = true,
                    signs = true,
                    virtual_text = true,
                },
                -- Inline diagnostics for failed tests
                diagnostic = {
                    enabled = true,
                    severity = vim.diagnostic.severity.ERROR,
                },
                -- Floating output window
                output = {
                    enabled = true,
                    open_on_run = false,
                },
                -- Summary panel on the right
                summary = {
                    enabled = true,
                    animated = true,
                    follow = true,
                    expand_errors = true,
                    mappings = {
                        expand = { "<CR>", "<2-LeftMouse>" },
                        expand_all = "e",
                        jumpto = "i",
                        output = "o",
                        run = "r",
                        short = "O",
                        stop = "u",
                        watch = "w",
                    },
                },
                -- Watch mode
                watch = {
                    enabled = true,
                },
                -- Quickfix integration
                quickfix = {
                    enabled = true,
                    open = false,
                },
            }
        end,
    }, -- Which-key group label for test keymaps
    {
        "folke/which-key.nvim",
        opts = {
            spec = { {
                "<leader>t",
                group = "test/terminal",
            } },
        },
    },
}
