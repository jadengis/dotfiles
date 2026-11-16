# Each package directory is a stow package and a just module:
#   just <package>          link it into $HOME and install its dependencies
#   just <package>::link    only link it
#   just <package>::unlink  remove its links

mod asdf
mod backup
mod cursor-agent
mod git
mod gnupg
mod mutt
mod neovim
mod taskwarrior

# List all recipes
[default]
list:
    @{{ just_executable() }} --justfile {{ quote(justfile()) }} --list --list-submodules

# Link every package into $HOME and install its dependencies
all: asdf::setup backup::setup cursor-agent::setup git::setup gnupg::setup mutt::setup neovim::setup taskwarrior::setup

# Remove every package's links from $HOME
clean: asdf::unlink backup::unlink cursor-agent::unlink git::unlink gnupg::unlink mutt::unlink neovim::unlink taskwarrior::unlink

# Install every package's dependencies without linking anything
install: asdf::install backup::install cursor-agent::install git::install gnupg::install mutt::install neovim::install taskwarrior::install

# Run the neovim config tests (optionally only the given files, e.g. tests/test_lsp.lua)
test *files: (neovim::test files)
