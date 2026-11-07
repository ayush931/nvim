local M = {}

function M.setup()
    local uv = vim.uv or vim.loop
    local home = vim.env.HOME or ""
    local paths = { vim.fn.stdpath("data") .. "/mason/bin" }
    if home ~= "" then
        vim.list_extend(paths, {
            home .. "/go/bin",
            home .. "/.local/go/bin",
            home .. "/.local/bin",
            home .. "/.bun/bin",
            home .. "/.cargo/bin",
        })
    end
    if vim.fn.has("mac") == 1 then
        -- GUI apps may inherit only /usr/bin:/bin:/usr/sbin:/sbin.
        -- Prefer native Homebrew on Apple Silicon, then the Intel prefix.
        local prefixes = uv.os_uname().machine == "arm64" and { "/opt/homebrew", "/usr/local" }
            or { "/usr/local", "/opt/homebrew" }
        for _, prefix in ipairs(prefixes) do
            paths[#paths + 1] = prefix .. "/bin"
            paths[#paths + 1] = prefix .. "/sbin"
        end
    end
    local inherited = vim.split(vim.env.PATH or "", ":", { plain = true, trimempty = true })
    local result, seen = {}, {}
    for _, path in ipairs(vim.list_extend(paths, inherited)) do
        if not seen[path] and (vim.tbl_contains(inherited, path) or uv.fs_stat(path)) then
            result[#result + 1] = path
            seen[path] = true
        end
    end
    vim.env.PATH = table.concat(result, ":")
end

return M
