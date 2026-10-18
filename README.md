# Dotfiles

[![Neovim Config Tests](https://github.com/jadengis/dotfiles/actions/workflows/neovim-tests.yml/badge.svg?branch=master)](https://github.com/jadengis/dotfiles/actions/workflows/neovim-tests.yml)

Configurations for various tools such as `asdf`, `git`, `mutt`, `neovim` and `taskwarrior`.

Tasks run with [`just`](https://github.com/casey/just). Use `just all` to install all configurations, `just <package>` (e.g. `just neovim`) to install one, and `just clean` to remove them all. Run `just` to list every recipe.

Run `just test` to test the neovim configuration (see `neovim/tests/`).
