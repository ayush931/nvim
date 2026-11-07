-- nvim --headless -u NONE -i NONE -l tests/formatting.lua
-- Exercise real clang-format through Conform's synchronous save hook.
local data = vim.fn.stdpath("data")
vim.opt.rtp:append(data .. "/lazy/conform.nvim")
vim.env.PATH = data .. "/mason/bin:" .. vim.env.PATH
local opts = dofile("lua/plugins/formatting.lua")[1].opts
opts.format_on_save = { timeout_ms = 3000, lsp_format = "never" }
require("conform").setup(opts)
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local source = { "int main() {", "\tif (true) {", "\t\treturn 0;", "\t}", "}" }
for _, project_style in ipairs({ false, true }) do
    if project_style then
        vim.fn.writefile({ "BasedOnStyle: LLVM", "IndentWidth: 2", "TabWidth: 8", "UseTab: Always", "BreakBeforeBraces: Allman" }, root .. "/.clang-format")
    end
    local path = root .. (project_style and "/project.cpp" or "/fallback.cpp")
    vim.cmd.edit(path)
    vim.bo.filetype = "cpp"
    dofile("after/ftplugin/cpp.lua")
    assert(vim.bo.shiftwidth == 4 and vim.bo.tabstop == 4 and vim.bo.softtabstop == 4 and vim.bo.expandtab)
    vim.api.nvim_buf_set_lines(0, 0, -1, false, source)
    vim.cmd.write()
    local formatted = vim.fn.readfile(path)
    assert(vim.tbl_contains(formatted, "    if (true)" .. (project_style and "" or " {")), vim.inspect(formatted))
    assert(vim.tbl_contains(formatted, "        return 0;"), vim.inspect(formatted))
    assert(not table.concat(formatted, "\n"):find("\t"), "formatter emitted tabs")
    if project_style then
        assert(formatted[1] == "int main()" and formatted[2] == "{", "project brace style lost")
    end
end
print("PASS C++ four-space editing and formatting on save, with and without project style")
vim.cmd("qa!")
