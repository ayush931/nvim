-- nvim --headless -u NONE -i NONE -l tests/completion-policy.lua
package.path = vim.fn.getcwd() .. "/lua/?.lua;" .. package.path
local transform = require("config.completion").without_arguments
local kind = vim.lsp.protocol.CompletionItemKind
local cases = {
    { kind = kind.Function, insertText = "fetch(${1:url}, ${2:options})$0", insertTextFormat = 2 },
    { kind = kind.Function, textEdit = { newText = "print(${1:objects}, ${2:sep})" }, insertTextFormat = 2 },
    { kind = kind.Method, textEditText = "append(value)", insertTextFormat = 1 },
    { kind = kind.Constructor, insertText = "Widget(${1:config})", insertTextFormat = 2 },
    { kind = kind.Function, insertText = "Atoi(${1:s string})", insertTextFormat = 2 },
}
for _, item in ipairs(cases) do
    local original = (item.textEdit and item.textEdit.newText) or item.textEditText or item.insertText
    local name = original:match("^(.-)%(")
    item.additionalTextEdits = { { newText = "import library" } }
    local result = transform(nil, { item })
    assert(#result == 1)
    local text = (item.textEdit and item.textEdit.newText) or item.textEditText or item.insertText
    assert(text == name .. "($0)", text)
    assert(tostring(vim.lsp._snippet_grammar.parse(text)) == name .. "()")
    assert(item.additionalTextEdits[1].newText == "import library", "auto-import removed")
    assert(transform(nil, result)[1].insertText == text, "resolve transform changed empty call")
end
local result = transform(nil, {
    { kind = kind.Snippet, insertText = "for ${1:i} in ${2:items}" },
    { kind = kind.Variable, insertText = "${1:value}", insertTextFormat = 2 },
    { kind = kind.Variable, insertText = "value", insertTextFormat = 1 },
    { kind = kind.Function, insertText = "len", insertTextFormat = 1 },
})
assert(#result == 2 and result[1].insertText == "value" and result[2].insertText == "len")
print("PASS JS/Python/Go methods and constructors: empty calls, no template suggestions, auto-imports preserved")
vim.cmd("qa!")
