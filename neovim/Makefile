
include ../common.mk

# command:dnf-package
PACKAGES := nvim:neovim git:git curl:curl rg:ripgrep fd:fd-find tree-sitter:tree-sitter-cli make:make gcc:gcc dotnet:dotnet-sdk-10.0

# Config tests run in a sandbox: plugins, parsers and state live in .tests/,
# never in ~/.local/share/nvim.
TEST_DIR := $(CURDIR)/.tests
TEST_ENV := XDG_CONFIG_HOME=$(TEST_DIR)/config XDG_DATA_HOME=$(TEST_DIR)/data \
	XDG_STATE_HOME=$(TEST_DIR)/state XDG_CACHE_HOME=$(TEST_DIR)/cache
MINI_TEST_VERSION := v0.18.0

.PHONY: all install check-deps lazygit test test-deps test-clean

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

# Run the config test suite (tests/test_*.lua) against the plugin versions in
# lazy-lock.json. Single file: make test FILE=tests/test_lsp.lua
test: test-deps
	@$(TEST_ENV) nvim --headless --noplugin -u tests/minimal_init.lua \
		-c "lua MiniTest.run($(if $(FILE),{ collect = { find_files = function() return { '$(FILE)' } end } },))"

# Install mini.test, then plugins at their locked commits and treesitter parsers.
test-deps:
	@# Link the config in, but give the sandbox its own copy of the lockfile so
	@# test runs can never rewrite the real one.
	@rm -rf $(TEST_DIR)/config && mkdir -p $(TEST_DIR)/config/nvim $(TEST_DIR)/deps
	@for f in $(CURDIR)/.config/nvim/*; do ln -s "$$f" $(TEST_DIR)/config/nvim/; done
	@rm $(TEST_DIR)/config/nvim/lazy-lock.json && cp $(CURDIR)/.config/nvim/lazy-lock.json $(TEST_DIR)/config/nvim/
	@[ -d $(TEST_DIR)/deps/mini.test ] || git clone --quiet --depth 1 --branch $(MINI_TEST_VERSION) \
		https://github.com/nvim-mini/mini.test $(TEST_DIR)/deps/mini.test
	@echo "Syncing test plugins with lazy-lock.json..."
	@$(TEST_ENV) nvim --headless -c "luafile tests/bootstrap.lua" >/dev/null

test-clean:
	rm -rf $(TEST_DIR)
