include ../common.mk

PACKAGES := task:task timew:timewarrior python3:python3 pip3:python3-pip
PYTHON_MODULES := bugwarrior:bugwarrior
SYSTEMD_UNITS := bugwarrior-pull.timer

.PHONY: all install check-deps install-python-deps enable-services

all: check-deps install-python-deps enable-services
	@echo "Taskwarrior ecosystem configuration complete"

install: check-deps install-python-deps enable-services
	@echo "Installing taskwarrior ecosystem..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))

install-python-deps:
	@echo "Installing Python dependencies..."
	$(foreach module,$(PYTHON_MODULES),$(call install_python_module,$(word 1,$(subst :, ,$(module))),$(word 2,$(subst :, ,$(module)))))

enable-services:
	$(call enable_systemd_user_units,$(SYSTEMD_UNITS))