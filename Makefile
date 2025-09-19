ALL_PACKAGES := asdf git mutt neovim taskwarrior
CLEAN_PACKAGES := $(ALL_PACKAGES:%=clean_%)

all: $(ALL_PACKAGES)
clean: $(CLEAN_PACKAGES)
.PHONY: all clean $(ALL_PACKAGES) $(CLEAN_PACKAGES)

$(ALL_PACKAGES):
	stow --no-folding --target=${HOME} $@
	-include ./${@}/Makefile

$(CLEAN_PACKAGES):
	stow --target=${HOME} --delete $(@:clean_%=%)
