.PHONY: all install check-deps install-python-deps

all: check-deps install-python-deps
	@echo "Taskwarrior ecosystem configuration complete"

install: check-deps install-python-deps
	@echo "Installing taskwarrior ecosystem..."

check-deps:
	@echo "Checking taskwarrior dependencies..."
	@if ! command -v task >/dev/null 2>&1; then \
		echo "Taskwarrior not found. Installing via dnf..."; \
		sudo dnf install -y task; \
	else \
		echo "Taskwarrior already installed"; \
	fi
	@if ! command -v timew >/dev/null 2>&1; then \
		echo "Timewarrior not found. Installing via dnf..."; \
		sudo dnf install -y timewarrior; \
	else \
		echo "Timewarrior already installed"; \
	fi
	@if ! command -v python3 >/dev/null 2>&1; then \
		echo "Python3 not found. Installing via dnf..."; \
		sudo dnf install -y python3 python3-pip; \
	else \
		echo "Python3 already installed"; \
	fi

install-python-deps:
	@echo "Installing Python dependencies for bugwarrior..."
	@if ! python3 -c "import bugwarrior" 2>/dev/null; then \
		echo "Installing bugwarrior via pip..."; \
		pip3 install --user bugwarrior; \
	else \
		echo "Bugwarrior already installed"; \
	fi