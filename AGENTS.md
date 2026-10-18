# AGENTS.md

This file provides guidance to AI coding agents (Claude Code, Codex, Cursor, etc.) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for managing configurations for various tools including `git`, `mutt`, `neovim`, `asdf`, and `taskwarrior`. The repository uses GNU Stow for symlink management.

## Common Commands

Tasks run with [`just`](https://github.com/casey/just) (`dnf install just` / `brew install just`). The root `justfile` loads each package's `justfile` as a module; `common.just` holds the shared recipes every package imports.

### Installation and Management
- `just` - List every recipe
- `just all` - Link all packages into `$HOME` and install their dependencies
- `just clean` - Remove all symlinked configurations
- `just install` - Install every package's dependencies without linking
- `just <package>` - Link and install one package (e.g., `just neovim`, `just git`)
- `just <package>::link` / `just <package>::unlink` - Only link, or remove the links for, one package
- `just <package>::install` - Only install one package's dependencies

Dependency installs use dnf on Linux (Fedora) and Homebrew on macOS (`[linux]`/`[macos]` recipes and `os()` checks); systemd units are skipped on macOS.

### Testing
- `just test` - Run the neovim config test suite (headless, sandboxed in `neovim/.tests/`)
- `just test tests/test_lsp.lua` - Run only the given test files (paths relative to `neovim/`)
- `just neovim::test-clean` - Delete the test sandbox (plugins/parsers are reinstalled on the next run)

Tests live in `neovim/tests/test_*.lua` ([mini.test](https://github.com/nvim-mini/mini.test)). Each case starts a child Neovim with the real config against the plugin commits in `lazy-lock.json`. After `:Lazy update`, run `just test` before committing the new lockfile. CI runs the same suite on changes under `neovim/` (`.github/workflows/neovim-tests.yml`).

### Individual Package Commands
- `stow --no-folding --target=${HOME} --ignore=justfile <package>` - Install specific package manually
- `stow --target=${HOME} --delete --ignore=justfile <package>` - Remove specific package manually

## Architecture

### Package Structure
Each tool configuration is organized as a separate "package" directory:
- `asdf/` - Version manager tool versions (.tool-versions)
- `cursor-agent/` - Cursor agent worker (systemd user service)
- `git/` - Git configuration (.gitconfig with GPG signing enabled)
- `mutt/` - Email client configuration (mbsync, msmtp, mutt configs)
- `neovim/` - Neovim configuration (Lua-based config with lazy.nvim); `neovim/justfile`, `neovim/tests/` and `neovim/.tests/` are excluded from stow via `neovim/.stow-local-ignore`
- `taskwarrior/` - Task management (task, timewarrior, bugwarrior configs)

### Stow Integration
- Uses GNU Stow with `--no-folding` flag to maintain directory structures
- Each package directory mirrors the target structure under `$HOME`
- Configuration files are placed in their expected locations (e.g., `.config/nvim/`)

### Key Technologies
- **Neovim**: Lua-based configuration with lazy.nvim plugin manager
- **Git**: GPG signing enabled, nvimdiff3 as merge tool
- **ASDF**: Managing Node.js, Erlang, and Elixir versions
- **Taskwarrior ecosystem**: Task, Timewarrior, and Bugwarrior integration

## Development Notes

- Neovim plugin specs live in `neovim/.config/nvim/lua/plugins/` (one file per concern, loaded with lazy.nvim's `import`); per-server LSP settings live in `after/lsp/`
- `neovim/justfile` installs external dependencies (`just neovim::install`) and runs the tests
- Git configuration includes GPG signing and verbose commits
- Taskwarrior setup includes systemd service configurations
- All packages can be installed individually or collectively via the main Makefile