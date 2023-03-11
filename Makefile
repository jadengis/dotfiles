HOME_DIR := ~
ALL_PACKAGES := git mutt neovim
CLEAN_PACKAGES := $(ALL_PACKAGES:%=clean_%)

all: $(ALL_PACKAGES)
clean: $(CLEAN_PACKAGES)
.PHONY: all clean $(ALL_PACKAGES) $(CLEAN_PACKAGES)

$(ALL_PACKAGES):
	stow --no-folding --target=$(HOME_DIR) $@

$(CLEAN_PACKAGES):
	stow --target=$(HOME_DIR) --delete $(@:clean_%=%)
