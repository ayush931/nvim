-- Lightweight standalone integration check: nvim --headless -u NONE -i NONE -l tests/clangd.lua
-- Does not load LazyVim, Mason, Treesitter, or unrelated background services.
local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
local data = vim.fn.stdpath("data")
vim.opt.rtp:append(data .. "/lazy/nvim-lspconfig")
local spec = dofile("lua/plugins/fullstack-ide.lua")[2].opts.servers.clangd
spec.cmd[1] = data .. "/mason/bin/clangd"
spec.cmd[#spec.cmd + 1] = "--background-index=false"
spec.cmd[#spec.cmd + 1] = "--log=error"
local path = root .. "/main.cpp"
vim.fn.writefile({ "// 日本語 😀", "int value = 1;", "int main() { return value; }" }, path)
vim.cmd.edit(path)
spec.root_dir = root
local id = assert(vim.lsp.start(spec))
local client = assert(vim.lsp.get_client_by_id(id))
assert(
    vim.wait(3000, function()
        return client.initialized
    end, 50),
    "clangd initialization timeout"
)
assert(client.offset_encoding == "utf-16", "encoding mismatch")
local buf = vim.api.nvim_get_current_buf()
local function symbols()
    local res = client:request_sync("textDocument/documentSymbol", {
        textDocument = { uri = vim.uri_from_bufnr(buf) },
    }, 2000, buf)
    assert(res and not res.err, vim.inspect(res))
    assert(res.result and #res.result > 0, "missing symbols")
end
symbols()
local syncs = 0
local original_notify = client.notify
client.notify = function(self, method, params, ...)
    if method == "textDocument/didChange" then
        for _, change in ipairs(params.contentChanges) do
            assert(not change.range, "incremental update sent")
            syncs = syncs + 1
        end
    end
    return original_notify(self, method, params, ...)
end
for i = 1, 3 do
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        "// 日本語 😀 " .. i,
        "int value = " .. i .. ";",
        "int main() { return value; }",
        "// remove me",
    })
    symbols()
    vim.api.nvim_buf_set_lines(buf, 3, -1, false, {})
    symbols()
end
assert(syncs >= 6, "full updates not exercised")
-- saveas announces the new URI through Neovim's didSave lifecycle.
vim.cmd.saveas(root .. "/renamed.cpp")
symbols()
vim.lsp.buf_detach_client(buf, id)
vim.lsp.buf_attach_client(buf, id)
symbols()
client:stop()
assert(
    vim.wait(1000, function()
        return client:is_stopped()
    end, 50),
    "clangd stop timeout"
)
print("PASS clangd Unicode edits, line deletion, full sync, rename, reattach")
vim.cmd("qa!")
