return {
  -- Auto-close and auto-rename HTML/JSX tags
  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    opts = {},
  },

  -- Show package versions inline in package.json
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    ft = "json",
    opts = {
      hide_up_to_date = true,
      hide_unstable_versions = true,
    },
    keys = {
      { "<leader>ps", function() require("package-info").show() end, desc = "Show Package Versions" },
      { "<leader>pu", function() require("package-info").update() end, desc = "Update Package" },
      { "<leader>pd", function() require("package-info").delete() end, desc = "Delete Package" },
      { "<leader>pc", function() require("package-info").change_version() end, desc = "Change Version" },
    },
  },

  -- Tailwind CSS color previews in completion menu
  {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    ft = { "html", "css", "javascript", "javascriptreact", "typescript", "typescriptreact", "svelte", "vue" },
    opts = {
      color_square_width = 2,
    },
  },
}
