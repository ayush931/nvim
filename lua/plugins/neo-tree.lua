-- Compact file-type labels render in ordinary fonts as well as Nerd Fonts.
local file_icons = {
    lua = "Lu", js = "JS", jsx = "Jx", ts = "TS", tsx = "Tx",
    json = "{}", jsonc = "{}", yaml = "Ym", yml = "Ym", toml = "Tm",
    html = "<>", css = "# ", scss = "# ", md = "Md", txt = "Tx",
    py = "Py", c = "C ", cpp = "C+", h = "H ", hpp = "H+",
    rs = "Rs", go = "Go", sh = "Sh", zsh = "Sh", sql = "Db",
    png = "Im", jpg = "Im", jpeg = "Im", svg = "Im", gif = "Im",
    lock = "Lk", gitignore = "Git",
}

return {
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            {
                "<leader>fT",
                function()
                    local file = vim.api.nvim_buf_get_name(0)
                    if file == "" or vim.bo.buftype ~= "" or vim.fn.filereadable(file) ~= 1 then
                        vim.notify("No saved file to reveal in Neo-tree", vim.log.levels.INFO)
                        return
                    end
                    require("neo-tree.command").execute({
                        action = "show",
                        source = "filesystem",
                        dir = _G.get_project_root(),
                        reveal_file = file,
                    })
                end,
                desc = "Reveal Current File in Neo-tree",
            },
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({
                        toggle = true,
                        dir = _G.get_project_root(),
                    })
                end,
                desc = "Explorer NeoTree (Root Dir)",
            },
            {
                "<leader>fE",
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
                    with_expanders = false,
                },
                icon = {
                    folder_closed = "[+]",
                    folder_open = "[-]",
                    folder_empty = "[+]",
                    folder_empty_open = "[-]",
                    default = "--",
                    selected = "*",
                    provider = function(icon, node)
                        if node.type == "file" then
                            local extension = node.name:match("%.([^%.]+)$")
                            icon.text = file_icons[(extension or ""):lower()] or "--"
                        elseif node.type == "terminal" then
                            icon.text = ">_"
                        end
                        return icon
                    end,
                },
                diagnostics = {
                    symbols = { error = "X", warn = "!", info = "i", hint = "H" },
                },
                git_status = {
                    symbols = {
                        added = "+", deleted = "-", modified = "M", renamed = "R",
                        untracked = "U", ignored = "I", unstaged = "~", staged = "S", conflict = "!",
                    },
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
