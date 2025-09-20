# Common utilities for dotfiles Makefiles

# Function to check if a command exists
check_command = $(shell command -v $(1) >/dev/null 2>&1 && echo "exists" || echo "missing")

# Function to install a dnf package if command is missing
define install_if_missing
	@if ! command -v $(1) >/dev/null 2>&1; then \
		echo "$(1) not found. Installing $(2) via dnf..."; \
		sudo dnf install -y $(2); \
	else \
		echo "$(1) already installed"; \
	fi
endef

# Function to install multiple dnf packages
define check_and_install_packages
	@echo "Checking dependencies..."
	@for pkg in $(1); do \
		cmd=$$(echo $$pkg | cut -d: -f1); \
		package=$$(echo $$pkg | cut -d: -f2); \
		if ! command -v $$cmd >/dev/null 2>&1; then \
			echo "$$cmd not found. Installing $$package via dnf..."; \
			sudo dnf install -y $$package; \
		else \
			echo "$$cmd already installed"; \
		fi; \
	done
endef

# Function to check Python module and install via pip if missing
define install_python_module
	@if ! python3 -c "import $(1)" 2>/dev/null; then \
		echo "Installing $(1) via pip..."; \
		pip3 install --user $(2); \
	else \
		echo "$(1) already installed"; \
	fi
endef

# Function to add content to file if not present
define add_to_file_if_missing
	@if ! grep -q '$(2)' $(1) 2>/dev/null; then \
		echo "Adding $(3) to $(1)..."; \
		echo '' >> $(1); \
		echo '$(2)' >> $(1); \
	else \
		echo "$(3) already configured in $(1)"; \
	fi
endef