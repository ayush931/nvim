return { -- Treesitter parsers for RN filetypes
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, {
                "tsx",
                "typescript",
                "javascript",
                "json",
                "xml",
                "kotlin",
                "swift",
                "groovy", -- for android/build.gradle
            })
            opts.ensure_installed = LazyVim.dedup(opts.ensure_installed)
            return opts
        end,
    }, -- React Native commands via which-key
    -- NOTE: eslint/vtsls/neotest-jest are configured once in
    -- turborepo.lua / completion.lua / testing.lua respectively (removed duplicate
    -- empty/subset blocks that used to live here and fought those definitions).
    {
        "folke/which-key.nvim",
        opts = function(_, opts)
            local function rn_term(cmd, direction, size)
                require("config.terminals").toggle(cmd, direction, size)
            end
            opts.spec = opts.spec or {}
            vim.list_extend(opts.spec, {
                {
                    "<leader>R",
                    group = "react-native",
                },
                {
                    "<leader>Rs",
                    function()
                        rn_term("npx react-native start", "float")
                    end,
                    desc = "Start Metro",
                },
                {
                    "<leader>Ra",
                    function()
                        rn_term("npx react-native run-android", "float")
                    end,
                    desc = "Run Android",
                },
                {
                    "<leader>Ri",
                    function()
                        rn_term("npx react-native run-ios", "float")
                    end,
                    desc = "Run iOS",
                },
                {
                    "<leader>Rl",
                    function()
                        rn_term("npx react-native log-android", "horizontal", 15)
                    end,
                    desc = "Logcat (Android)",
                },
                {
                    "<leader>Rd",
                    "<cmd>!adb shell input keyevent 82<cr>",
                    desc = "Open Dev Menu (Android)",
                },
                {
                    "<leader>Rr",
                    "<cmd>!adb shell input text 'RR'<cr>",
                    desc = "Reload (Android)",
                },
            })
            return opts
        end,
    },
}
