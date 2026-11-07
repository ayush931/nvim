return {
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                cpp = { "clang-format" },
                c = { "clang-format" },
                cuda = { "clang-format" },
                proto = { "clang-format" },
            },
            formatters = {
                -- NOTE: no custom --tab-width for prettier/prettierd on purpose.
                -- Forcing 4 spaces broke JS/TS projects that configure 2 spaces via
                -- .prettierrc / package.json. Let the project config decide instead.
                ["clang-format"] = {
                    prepend_args = {
                        -- Keep project style rules, but always use four-space indentation.
                        "--style={BasedOnStyle: InheritParentConfig, IndentWidth: 4, TabWidth: 4, ContinuationIndentWidth: 4, UseTab: Never}",
                        "--fallback-style=Google",
                    },
                },
            },
        },
    },
}
