.PHONY: all install check-deps

all: check-deps
	@echo "Git configuration ready"

install: check-deps
	@echo "Installing git dependencies..."

check-deps:
	@echo "Checking git dependencies..."
	@if ! command -v git >/dev/null 2>&1; then \
		echo "Git not found. Installing via dnf..."; \
		sudo dnf install -y git; \
	else \
		echo "Git already installed"; \
	fi
	@if ! command -v gnupg2 >/dev/null 2>&1; then \
		echo "GnuPG not found. Installing via dnf (needed for GPG signing)..."; \
		sudo dnf install -y gnupg2; \
	else \
		echo "GnuPG already installed"; \
	fi