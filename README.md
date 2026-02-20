# ⚡ Ultimate LazyVim IDE Config

This repository is an opinionated **full-spectrum LazyVim setup** designed to cover:

- Web development (JS/TS, React, Next.js, Tailwind, Prisma)
- Mobile development (React Native)
- AI/ML and data-science workflows (Python env/debug/repl + CSV tooling)
- Web3-ready foundations (TS/JS + infra stack + fast testing/debugging)
- Backend/platform engineering (Go, Rust, SQL, Docker, Terraform)

## Included highlights

- Strong LSP + completion stack (vtsls-focused TS experience, Tailwind, Emmet, JSON schemas)
- Broad Mason auto-install list for LSPs, formatters/linters, and debuggers
- Expanded Treesitter parser coverage for polyglot monorepos
- Better Telescope workflow (live grep args, ui-select, recent files/keymaps)
- Database workflow support via Dadbod UI
- AI tooling via Copilot + Python venv selector + REPL + DAP Python

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

## Notes on Go and Ruff


If your platform has Mason issues with `gopls` or `ruff`, this config avoids forcing their Mason installation and enables those LSPs only when the binaries are already available on your system (`gopls`, `ruff`).
