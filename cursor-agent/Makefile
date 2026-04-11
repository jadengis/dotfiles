include ../common.mk

SYSTEMD_UNITS := cursor-agent-worker.service

.PHONY: all install enable-services do-enable-services

all: enable-services
	@echo "Cursor agent worker configuration complete"

install: enable-services
	@echo "Installing Cursor agent worker..."

enable-services:
	@if command -v agent >/dev/null 2>&1; then \
		$(MAKE) do-enable-services; \
	else \
		echo "agent not found; install via: curl https://cursor.com/install -fsS | bash"; \
		echo "Then run: agent login   (or set --api-key in ~/.config/cursor-agent/worker.env)"; \
		echo "Then rerun: make -C cursor-agent install"; \
	fi

do-enable-services:
	@systemctl --user daemon-reload
	@$(call enable_systemd_user_units,$(SYSTEMD_UNITS))
