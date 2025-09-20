
.PHONY: all install check-deps

all: check-deps
	@echo "Neovim configuration ready"

install: check-deps
	@echo "Installing neovim dependencies..."

check-deps:
	@echo "Checking neovim dependencies..."
	@if ! command -v nvim >/dev/null 2>&1; then \
		echo "Neovim not found. Installing via dnf..."; \
		sudo dnf install -y neovim; \
	else \
		echo "Neovim already installed"; \
	fi
	@if ! command -v git >/dev/null 2>&1; then \
		echo "Git not found. Installing via dnf..."; \
		sudo dnf install -y git; \
	else \
		echo "Git already installed"; \
	fi
	@if ! command -v curl >/dev/null 2>&1; then \
		echo "Curl not found. Installing via dnf..."; \
		sudo dnf install -y curl; \
	else \
		echo "Curl already installed"; \
	fi
