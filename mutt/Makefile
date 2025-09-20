.PHONY: all install check-deps

all: check-deps
	@echo "Mutt email configuration complete"

install: check-deps
	@echo "Installing mutt and email tools..."

check-deps:
	@echo "Checking mutt and email dependencies..."
	@if ! command -v mutt >/dev/null 2>&1; then \
		echo "Mutt not found. Installing via dnf..."; \
		sudo dnf install -y mutt; \
	else \
		echo "Mutt already installed"; \
	fi
	@if ! command -v mbsync >/dev/null 2>&1; then \
		echo "Mbsync not found. Installing via dnf..."; \
		sudo dnf install -y isync; \
	else \
		echo "Mbsync already installed"; \
	fi
	@if ! command -v msmtp >/dev/null 2>&1; then \
		echo "Msmtp not found. Installing via dnf..."; \
		sudo dnf install -y msmtp; \
	else \
		echo "Msmtp already installed"; \
	fi
	@if ! command -v urlview >/dev/null 2>&1; then \
		echo "Urlview not found. Installing via dnf..."; \
		sudo dnf install -y urlview; \
	else \
		echo "Urlview already installed"; \
	fi
	@if ! command -v gpg >/dev/null 2>&1; then \
		echo "GnuPG not found. Installing via dnf..."; \
		sudo dnf install -y gnupg2; \
	else \
		echo "GnuPG already installed"; \
	fi