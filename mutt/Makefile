include ../common.mk

PACKAGES := neomutt:neomutt mbsync:isync msmtp:msmtp urlview:urlview gpg:gnupg2
SYSTEMD_UNITS := mbsync.timer

.PHONY: all install check-deps enable-services

all: check-deps enable-services
	@echo "Neomutt email configuration complete"

install: check-deps enable-services
	@echo "Installing neomutt and email tools..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))

enable-services:
	$(call enable_systemd_user_units,$(SYSTEMD_UNITS))