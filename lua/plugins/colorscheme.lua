return { -- Add the VS Code theme plugin
{
    "Mofiqul/vscode.nvim",
    -- Make sure this loads first
    lazy = false,
    priority = 1000,
    opts = {
        -- Set the style to "dark" or "light" as desired
        style = "dark",

        -- Use terminal background everywhere
        transparent = true,

        -- Adjust specific colors if needed (optional)
        color_overrides = {},

        -- Configure which plugins this theme should integrate with
        integrations = {
            telescope = true,
            nvimtree = true,
            cmp = true,
            gitsigns = true,
            lualine = true
        }
    },
    -- Load the colorscheme on startup
    config = function()
        vim.cmd("colorscheme vscode")

        local function apply_transparency()
            local groups = {"Normal", "NormalNC", "NormalFloat", "NormalSB", "FloatBorder", "SignColumn", "FoldColumn",
                            "LineNr", "CursorLineNr", "EndOfBuffer", "StatusLine", "StatusLineNC", "TabLine",
                            "TabLineFill", "WinBar", "WinBarNC", "WinSeparator", "VertSplit", "Pmenu", "PmenuSbar",
                            "PmenuThumb", "NvimTreeNormal", "NvimTreeNormalNC", "NeoTreeNormal", "NeoTreeNormalNC",
                            "NeoTreeFloatNormal", "NeoTreeFloatBorder", "TelescopeNormal", "TelescopeBorder",
                            "TelescopePromptNormal", "TelescopePromptBorder", "TelescopeResultsNormal",
                            "TelescopeResultsBorder", "TelescopePreviewNormal", "TelescopePreviewBorder",
                            "TroubleNormal", "TroubleNormalNC", "LazyNormal", "MasonNormal", "WhichKeyFloat",
                            "NoiceCmdlinePopup", "NoiceCmdlinePopupBorder", "NoicePopup", "NoicePopupBorder",
                            "NotifyBackground"}

            for _, group in ipairs(groups) do
                vim.api.nvim_set_hl(0, group, {
                    bg = "none",
                    ctermbg = "none"
                })
            end
        end

        apply_transparency()
        vim.api.nvim_create_autocmd("ColorScheme", {
            callback = apply_transparency
        })
    end
}}
