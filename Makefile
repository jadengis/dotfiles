ALL_PACKAGES := asdf git mutt neovim taskwarrior
CLEAN_PACKAGES := $(ALL_PACKAGES:%=clean_%)
INSTALL_PACKAGES := $(ALL_PACKAGES:%=install_%)

all: $(ALL_PACKAGES)
clean: $(CLEAN_PACKAGES)
install: $(INSTALL_PACKAGES)
.PHONY: all clean install $(ALL_PACKAGES) $(CLEAN_PACKAGES) $(INSTALL_PACKAGES)

# Helper function to check if a command exists
check_command = $(shell command -v $(1) >/dev/null 2>&1 && echo "exists" || echo "missing")

$(ALL_PACKAGES):
	@echo "Installing $@ configuration..."
	stow --no-folding --target=${HOME} --ignore='Makefile' $@
	@if [ -f ./$@/Makefile ]; then \
		$(MAKE) -C $@ install; \
	fi

$(CLEAN_PACKAGES):
	@echo "Removing $(@:clean_%=%) configuration..."
	stow --target=${HOME} --delete --ignore='Makefile' $(@:clean_%=%)

$(INSTALL_PACKAGES):
	@if [ -f ./$(@:install_%=%)/Makefile ]; then \
		$(MAKE) -C $(@:install_%=%) install; \
	else \
		echo "No installation target for $(@:install_%=%)"; \
	fi
