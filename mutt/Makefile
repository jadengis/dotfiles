include ../common.mk

PACKAGES := mutt:mutt mbsync:isync msmtp:msmtp urlview:urlview gpg:gnupg2

.PHONY: all install check-deps

all: check-deps
	@echo "Mutt email configuration complete"

install: check-deps
	@echo "Installing mutt and email tools..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))