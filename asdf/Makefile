include ../common.mk

PACKAGES := git:git curl:curl
ASDF_PLUGINS := nodejs erlang elixir

.PHONY: all install check-deps install-asdf install-plugins install-versions

all: check-deps install-plugins install-versions
	@echo "ASDF configuration complete"

install: check-deps install-plugins install-versions
	@echo "Installing ASDF and language versions..."

check-deps: install-asdf
	$(call check_and_install_packages,$(PACKAGES))

install-asdf:
	@echo "Checking ASDF installation..."
	@if [ ! -d "${HOME}/.asdf" ]; then \
		echo "ASDF not found. Installing..."; \
		git clone https://github.com/asdf-vm/asdf.git ${HOME}/.asdf --branch v0.14.0; \
	else \
		echo "ASDF already installed"; \
	fi
	$(call add_to_file_if_missing,${HOME}/.bashrc,. "$${HOME}/.asdf/asdf.sh",ASDF sourcing)
	$(call add_to_file_if_missing,${HOME}/.bashrc,. "$${HOME}/.asdf/completions/asdf.bash",ASDF completions)

install-plugins:
	@echo "Installing ASDF plugins..."
	@export PATH="${HOME}/.asdf/bin:${PATH}" && \
	. "${HOME}/.asdf/asdf.sh" && \
	for plugin in $(ASDF_PLUGINS); do \
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