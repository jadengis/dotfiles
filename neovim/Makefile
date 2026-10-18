
include ../common.mk

# command:dnf-package
PACKAGES := nvim:neovim git:git curl:curl rg:ripgrep fd:fd-find tree-sitter:tree-sitter-cli make:make gcc:gcc

.PHONY: all install check-deps lazygit

all: check-deps
	@echo "Neovim configuration ready"

install: check-deps lazygit
	@echo "Installing neovim dependencies..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))

# lazygit (used by Snacks.lazygit) isn't in the Fedora repos; it comes from COPR.
lazygit:
	@if ! command -v lazygit >/dev/null 2>&1; then \
		echo "lazygit not found. Installing from COPR atim/lazygit..."; \
		sudo dnf copr enable -y atim/lazygit && sudo dnf install -y lazygit; \
	else \
		echo "lazygit already installed"; \
	fi
