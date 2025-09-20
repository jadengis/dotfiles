# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository for managing configurations for various tools including `git`, `mutt`, `neovim`, `asdf`, and `taskwarrior`. The repository uses GNU Stow for symlink management.

## Common Commands

### Installation and Management
- `make all` - Install all dotfile configurations using stow
- `make clean` - Remove all symlinked configurations
- `make <package>` - Install specific package (e.g., `make neovim`, `make git`)
- `make clean_<package>` - Remove specific package configuration

### Individual Package Commands
- `stow --no-folding --target=${HOME} <package>` - Install specific package manually
- `stow --target=${HOME} --delete <package>` - Remove specific package manually

## Architecture

### Package Structure
Each tool configuration is organized as a separate "package" directory:
- `asdf/` - Version manager tool versions (.tool-versions)
- `git/` - Git configuration (.gitconfig with GPG signing enabled)
- `mutt/` - Email client configuration (mbsync, msmtp, mutt configs)
- `neovim/` - Neovim configuration (Lua-based config with lazy.nvim)
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

- Neovim configuration uses lazy.nvim and has a placeholder Makefile
- Git configuration includes GPG signing and verbose commits
- Taskwarrior setup includes systemd service configurations
- All packages can be installed individually or collectively via the main Makefile