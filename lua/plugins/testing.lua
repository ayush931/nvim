return { -- Neotest: unified test runner UI (run/debug tests like VS Code Testing panel)
{
    "nvim-neotest/neotest",
    dependencies = {"nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter", -- Test adapters
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
                -- Safely locate the nearest jest config; return nil (auto-discover)
                -- instead of a non-existent path (previously always returned
                -- jest.config.ts even when only .js/.cjs or package.json existed).
                local ok_util, jest_util = pcall(require, "neotest-jest.util")
                local root
                if ok_util and jest_util then
                    local ok_root, ancestor = pcall(jest_util.find_package_json_ancestor, file)
                    if ok_root then
                        root = ancestor
                    end
                end
                root = root or ((_G.get_project_root and _G.get_project_root()) or vim.fn.getcwd())
                for _, name in ipairs({
                    "jest.config.ts", "jest.config.js", "jest.config.cjs", "jest.config.mjs",
                    "jest.config.cts", "jest.config.mts", "jest.config.json",
                }) do
                    local candidate = root .. "/" .. name
                    if vim.fn.filereadable(candidate) == 1 then
                        return candidate
                    end
                end
                return nil
            end,
            env = {
                CI = "true"
            },
            cwd = function(file)
                local ok_util, jest_util = pcall(require, "neotest-jest.util")
                if ok_util and jest_util then
                    local ok_root, ancestor = pcall(jest_util.find_package_json_ancestor, file)
                    if ok_root and ancestor and ancestor ~= "" then
                        return ancestor
                    end
                end
                if _G.get_project_root then
                    local ok_root, root = pcall(_G.get_project_root)
                    if ok_root and root and root ~= "" then
                        return root
                    end
                end
                return vim.fn.getcwd()
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
            group = "test/terminal"
        }}
    }
}}
