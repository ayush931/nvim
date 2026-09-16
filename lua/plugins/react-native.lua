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
}, -- React Native commands via which-key
-- NOTE: eslint/vtsls/neotest-jest are configured once in
-- turborepo.lua / completion.lua / testing.lua respectively (removed duplicate
-- empty/subset blocks that used to live here and fought those definitions).
{
    "folke/which-key.nvim",
    opts = function(_, opts)
        local function rn_term(cmd, direction, size)
            _G._rn_terms = _G._rn_terms or {}
            local key = cmd .. "|" .. (direction or "float")
            local term = _G._rn_terms[key]
            if term then
                term:toggle()
                return
            end
            term = require("toggleterm.terminal").Terminal:new({
                cmd = cmd,
                direction = direction or "float",
                size = size,
                close_on_exit = false,
                on_exit = function()
                    _G._rn_terms[key] = nil
                end,
            })
            _G._rn_terms[key] = term
            term:toggle()
        end
        opts.spec = opts.spec or {}
        vim.list_extend(opts.spec, {{
            "<leader>R",
            group = "react-native"
        }, {
            "<leader>Rs",
            function()
                rn_term("npx react-native start", "float")
            end,
            desc = "Start Metro"
        }, {
            "<leader>Ra",
            function()
                rn_term("npx react-native run-android", "float")
            end,
            desc = "Run Android"
        }, {
            "<leader>Ri",
            function()
                rn_term("npx react-native run-ios", "float")
            end,
            desc = "Run iOS"
        }, {
            "<leader>Rl",
            function()
                rn_term("npx react-native log-android", "horizontal", 15)
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
        }})
        return opts
    end
}}
