return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            {
                "<leader>e",
                function()
                    require("neo-tree.command").execute({
                        toggle = true,
                        dir = _G.get_project_root(),
                    })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>E",
                function()
                    require("neo-tree.command").execute({
                        toggle = true,
                        dir = (vim.uv or vim.loop).cwd(),
                    })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
        },
        opts = {
            default_component_configs = {
                indent = {
                    indent_size = 2,
                    padding = 1,
                    with_expanders = true,
                },
            },
            filesystem = {
                bind_to_cwd = false,
                use_libuv_file_watcher = false,
                filtered_items = {
                    visible = true,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    hide_hidden = false,
                },
                follow_current_file = {
                    enabled = false,
                    leave_dirs_open = false,
                },
                window = {
                    mappings = {
                        ["<space>"] = "none",
                    },
                },
            },
            event_handlers = {
                {
                    event = "file_added",
                    handler = function(path)
                        if type(path) == "string" and path ~= "" and vim.fn.isdirectory(path) == 0 then
                            local win = vim.api.nvim_get_current_win()
                            local buf = vim.api.nvim_win_get_buf(win)
                            local tab = vim.api.nvim_win_get_tabpage(win)
                            local state = require("neo-tree.sources.manager").get_state("filesystem", tab, win)
                            vim.schedule(function()
                                if
                                    vim.api.nvim_win_is_valid(win)
                                    and vim.api.nvim_win_get_buf(win) == buf
                                    and vim.api.nvim_get_current_tabpage() == tab
                                    and vim.fn.filereadable(path) == 1
                                then
                                    vim.api.nvim_win_call(win, function()
                                        require("neo-tree.utils").open_file(state, path)
                                    end)
                                end
                            end)
                        end
                    end,
                },
            },
        },
    },
}
