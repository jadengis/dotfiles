include ../common.mk

PACKAGES := git:git gnupg2:gnupg2

.PHONY: all install check-deps

all: check-deps
	@echo "Git configuration ready"

install: check-deps
	@echo "Installing git dependencies..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))