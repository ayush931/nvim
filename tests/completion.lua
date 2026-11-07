-- nvim --headless -u NONE -i NONE -l tests/completion.lua
package.path = vim.fn.getcwd() .. "/lua/?.lua;" .. package.path
require("config.environment").setup()
vim.opt.rtp:append(vim.fn.stdpath("data") .. "/lazy/blink.cmp")
local completion = dofile("lua/plugins/completion.lua")
local capabilities = completion[1].opts.servers["*"].capabilities
assert(capabilities.textDocument.completion.completionItem.snippetSupport == false)
local blink
for _, spec in ipairs(completion) do
    if spec[1] == "saghen/blink.cmp" then
        blink = spec.opts
    end
end
assert(blink.completion.accept.auto_brackets.enabled)
local servers = dofile("lua/plugins/fullstack-ide.lua")[2].opts.servers
assert(servers.gopls.settings.gopls.usePlaceholders == false)
assert(vim.tbl_contains(servers.clangd.cmd, "--function-arg-placeholders=0"))
assert(servers.lua_ls.settings.Lua.completion.callSnippet == "Disable")
assert(servers.rust_analyzer.settings["rust-analyzer"].completion.callable.snippets == "add_parentheses")

local root = vim.fn.tempname()
vim.fn.mkdir(root, "p")
vim.fn.writefile({ "module completion.test", "", "go 1.22" }, root .. "/go.mod")
local path = root .. "/main.go"
local lines = { "package main", 'import "strconv"', "func main() {", "    strconv.Ato", "}" }
vim.fn.writefile(lines, path)
vim.cmd.edit(path)
vim.bo.filetype = "go"
local id = assert(vim.lsp.start({
    name = "gopls",
    cmd = { vim.fn.exepath("gopls") },
    root_dir = root,
    capabilities = require("blink.cmp").get_lsp_capabilities(capabilities),
    settings = servers.gopls.settings,
}))
local client = assert(vim.lsp.get_client_by_id(id))
assert(vim.wait(10000, function() return client.initialized end, 50), "gopls initialization timed out")
local response = client:request_sync("textDocument/completion", {
    textDocument = { uri = vim.uri_from_bufnr(0) },
    position = { line = 3, character = #lines[4] },
    context = { triggerKind = 1 },
}, 15000, 0)
assert(response and not response.err, vim.inspect(response))
local atoi
for _, item in ipairs(response.result.items or response.result) do
    if item.label:match("^Atoi") then atoi = item end
end
assert(atoi, "gopls did not return Atoi")
local text = atoi.textEdit and atoi.textEdit.newText or atoi.insertText or atoi.label
assert(text == "Atoi" or text == "Atoi()", "unexpected argument insertion: " .. text)
-- Exercise Blink's actual bracket insertion for the completion returned by gopls.
if not atoi.textEdit then
    atoi.textEdit = { newText = text, range = { start = { line = 3, character = 12 }, ["end"] = { line = 3, character = #lines[4] } } }
end
atoi.textEdit.range = atoi.textEdit.range or atoi.textEdit.replace or atoi.textEdit.insert
vim.api.nvim_win_set_cursor(0, { 4, #lines[4] })
local _, edit = require("blink.cmp.completion.brackets.kind")({ mode = "default" }, "go", atoi)
assert(edit.newText == "Atoi()", "expected empty call, got: " .. edit.newText)
client:stop(true)
print("PASS real gopls Atoi completion + Blink empty parentheses; argument placeholders disabled across servers")
vim.cmd("qa!")
