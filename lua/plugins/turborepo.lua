return { -- Turborepo keymaps
{
    "folke/which-key.nvim",
    opts = function(_, opts)
        -- Reuse one terminal per turbo command instead of :new() on every
        -- keypress (previously leaked a hidden terminal per invocation and
        -- stacked duplicate floats).
        local function turbo_term(cmd)
            _G._turbo_terms = _G._turbo_terms or {}
            local term = _G._turbo_terms[cmd]
            if not term then
                term = require("toggleterm.terminal").Terminal:new({
                    cmd = cmd,
                    direction = "float",
                    close_on_exit = false,
                    on_exit = function()
                        -- Drop the reference so a finished `build`/`lint` run
                        -- starts fresh next time instead of re-showing old output.
                        _G._turbo_terms[cmd] = nil
                    end,
                })
                _G._turbo_terms[cmd] = term
            end
            term:toggle()
        end
        opts.spec = opts.spec or {}
        vim.list_extend(opts.spec, {{
            "<leader>T",
            group = "turbo"
        }, {
            "<leader>Tt",
            function()
                turbo_term("pnpm turbo run dev")
            end,
            desc = "Turbo Dev"
        }, {
            "<leader>Tb",
            function()
                turbo_term("pnpm turbo run build")
            end,
            desc = "Turbo Build"
        }, {
            "<leader>Tl",
            function()
                turbo_term("pnpm turbo run lint")
            end,
            desc = "Turbo Lint"
        }, {
            "<leader>Tc",
            function()
                turbo_term("pnpm turbo run check-types")
            end,
            desc = "Turbo Type Check"
        }, {
            "<leader>Te",
            function()
                turbo_term("pnpm turbo run test")
            end,
            desc = "Turbo Test"
        }})
        return opts
    end
}, -- Monorepo-aware file navigation with telescope
{
    "nvim-telescope/telescope.nvim",
    keys = {{
        "<leader>fw",
        function()
            local root = (_G.get_project_root and _G.get_project_root()) or vim.fn.getcwd()
            require("telescope.builtin").find_files({
                prompt_title = "Find in Workspace Packages",
                cwd = root,
                search_dirs = { root .. "/packages", root .. "/apps" },
            })
        end,
        desc = "Find Files (packages/apps)"
    }, {
        "<leader>sp",
        function()
            local root = (_G.get_project_root and _G.get_project_root()) or vim.fn.getcwd()
            require("telescope.builtin").live_grep({
                prompt_title = "Grep in Workspace Packages",
                cwd = root,
                search_dirs = { "packages", "apps" },
            })
        end,
        desc = "Grep (packages/apps)"
    }}
}, -- ESLint integration scoped to workspace (respects root eslint config)
{
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            eslint = {
                filetypes = {
                    "javascript", "javascriptreact", "typescript", "typescriptreact",
                    "vue", "svelte", "astro",
                },
                settings = {
                    workingDirectories = {
                        mode = "auto"
                    },
                    -- Support both legacy .eslintrc and flat eslint.config.js
                    useFlatConfig = true,
                },
            },
        },
    },
}}
