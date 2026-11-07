local M = {}

-- Run for every provider, including items returned by completionItem/resolve.
-- Keep function names and empty parentheses; never expand argument templates.
function M.without_arguments(_, items)
    local kinds = vim.lsp.protocol.CompletionItemKind
    return vim.tbl_filter(function(item)
        local callable = item.kind == kinds.Function or item.kind == kinds.Method or item.kind == kinds.Constructor
        local text = (item.textEdit and item.textEdit.newText) or item.textEditText or item.insertText or item.label
        if callable then
            local name = text:match("^([^\r\n]-)%(")
            if name and not name:find("$", 1, true) then
                local empty_call = name .. "($0)"
                if item.textEdit then
                    item.textEdit.newText = empty_call
                end
                item.insertText = empty_call
                if item.textEditText then
                    item.textEditText = empty_call
                end
                item.insertTextFormat = vim.lsp.protocol.InsertTextFormat.Snippet
                return true
            end
        end
        -- Servers can ignore snippetSupport=false. Block their remaining templates too.
        return item.kind ~= kinds.Snippet and item.insertTextFormat ~= vim.lsp.protocol.InsertTextFormat.Snippet
    end, items)
end

return M
