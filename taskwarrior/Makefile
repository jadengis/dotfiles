include ../common.mk

PACKAGES := task:task timew:timewarrior python3:python3 pip3:python3-pip
PYTHON_MODULES := bugwarrior:bugwarrior

.PHONY: all install check-deps install-python-deps

all: check-deps install-python-deps
	@echo "Taskwarrior ecosystem configuration complete"

install: check-deps install-python-deps
	@echo "Installing taskwarrior ecosystem..."

check-deps:
	$(call check_and_install_packages,$(PACKAGES))

install-python-deps:
	@echo "Installing Python dependencies..."
	$(foreach module,$(PYTHON_MODULES),$(call install_python_module,$(word 1,$(subst :, ,$(module))),$(word 2,$(subst :, ,$(module)))))