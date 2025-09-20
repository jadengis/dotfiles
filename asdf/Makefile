.PHONY: all install check-deps install-asdf install-plugins install-versions

all: check-deps install-plugins install-versions
	@echo "ASDF configuration complete"

install: check-deps install-plugins install-versions
	@echo "Installing ASDF and language versions..."

check-deps: install-asdf
	@echo "Checking ASDF dependencies..."
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

install-asdf:
	@echo "Checking ASDF installation..."
	@if [ ! -d "${HOME}/.asdf" ]; then \
		echo "ASDF not found. Installing..."; \
		git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.14.0; \
	else \
		echo "ASDF already installed"; \
	fi
	@if ! grep -q 'source.*asdf' ${HOME}/.bashrc 2>/dev/null; then \
		echo "Adding ASDF to .bashrc..."; \
		echo '' >> ${HOME}/.bashrc; \
		echo '. "$${HOME}/.asdf/asdf.sh"' >> ${HOME}/.bashrc; \
		echo '. "$${HOME}/.asdf/completions/asdf.bash"' >> ${HOME}/.bashrc; \
	else \
		echo "ASDF already configured in .bashrc"; \
	fi

install-plugins:
	@echo "Installing ASDF plugins..."
	@export PATH="${HOME}/.asdf/bin:${PATH}" && \
	. "${HOME}/.asdf/asdf.sh" && \
	for plugin in nodejs erlang elixir; do \
		if ! asdf plugin list | grep -q "^$$plugin$$"; then \
			echo "Installing $$plugin plugin..."; \
			asdf plugin add $$plugin; \
		else \
			echo "$$plugin plugin already installed"; \
		fi; \
	done

install-versions:
	@echo "Installing language versions from .tool-versions..."
	@if [ -f .tool-versions ]; then \
		export PATH="${HOME}/.asdf/bin:${PATH}" && \
		. "${HOME}/.asdf/asdf.sh" && \
		asdf install; \
	else \
		echo "No .tool-versions file found"; \
	fi