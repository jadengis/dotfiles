
include ../common.mk

PACKAGES := nvim:neovim git:git curl:curl

.PHONY: all install check-deps

all: check-deps
	@echo "Neovim configuration ready"

install: check-deps
	@echo "Installing neovim dependencies..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))
