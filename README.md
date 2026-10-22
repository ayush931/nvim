# ⚡ Ultimate LazyVim IDE Config

This repository is an opinionated **full-spectrum LazyVim setup** designed to cover:

- Web development (JS/TS, React, Next.js, Tailwind, Prisma)
- Mobile development (React Native)
- AI/ML and data-science workflows (Python environments/debugging + CSV syntax support)
- Web3-ready foundations (TS/JS + infra stack + fast testing/debugging)
- Backend/platform engineering (Go, Rust, SQL, Docker, Terraform)

## Included highlights

- Strong LSP + completion stack (vtsls-focused TS experience, Tailwind, Emmet, JSON schemas)
- Broad Mason auto-install list for LSPs, formatters/linters, and debuggers
- Expanded Treesitter parser coverage for polyglot monorepos
- Better Telescope workflow (live grep args, ui-select, recent files/keymaps)
- Database workflow support via Dadbod UI
- Python virtual environment selector and DAP Python debugging

## Philosophy

This config tries to feel like a modern IDE while staying fast and keyboard-driven:

- sensible defaults
- rich navigation and code intelligence
- language coverage for polyglot monorepos
- minimal friction for frontend + backend + infra + data work

## Getting started

```bash
nvim
```

Then run:

```vim
:Lazy sync
:Mason
```

Use `:checkhealth` to validate toolchain availability.


## Notes on Go and Ruff


If your platform has Mason issues with `gopls` or `ruff`, this config avoids forcing their Mason installation and enables those LSPs only when the binaries are already available on your system (`gopls`, `ruff`).


## Clangd stability and CPU use

Clangd uses standard UTF-16 position negotiation, full-document synchronization, and at most two workers. Full synchronization avoids the rejected incremental updates that caused `-32602: trying to get AST for non-added document`. Restart Neovim after changing the configuration.

Neotest discovery uses one worker and skips generated directories. Package version queries run on demand with `<leader>ps`. Plugin installation runs at most two jobs concurrently.

Automatic code-lens refresh is disabled; use `<leader>cC` to refresh manually. Automatic signature help is off initially; `<leader>us` toggles it. Diagnostic floats support normal `y`/`yy` selection and `Y` to copy the entire message.

The configuration checks validate file filtering, workspace search, Jest config lookup, mapping ownership, and terminal lifecycle without loading plugins:

```sh
nvim --headless -u NONE -i NONE -l tests/config.lua
```

A lightweight clangd integration check exercises Unicode edits, line deletion, save-as rename, and detach/reattach without loading the plugin stack:

```sh
nvim --headless -u NONE -i NONE -l tests/clangd.lua
```

`tests/regression.lua` checks installed plugin setup, signature mappings, autocmd reloads, and diagnostic float focus/close behavior. Its header contains the invocation.
