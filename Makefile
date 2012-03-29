# Run validation tests

WESNOTH_VERSION ?= $(shell wesnoth-1.10 --version 2>&1 | tail -n 1)
WESNOTH_DATA_DIR ?= $(shell wesnoth-1.10 --path 2>&1 | tail -n 1)
WESNOTH_CORE_DIR ?= $(WESNOTH_DATA_DIR)/data/core

DEFSCOPE ?= macro-scope-check
WMLLINT ?= wmllint-1.10
WMLINDENT ?= wmlindent-1.10
OPTIPNG ?= wesnoth-optipng
WML_PREPROCESS ?= wesnoth-1.10 -p

MAKEFLAGS += -rR --no-print-directory

# Internal variables

targetdir := $(realpath .)

difficulties := EASY NORMAL HARD
packs := \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_I \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_II

preprocesscmd = $(WML_PREPROCESS) $(targetdir) $(scratchdir) --preprocess-defines CAMPAIGN_AFTER_THE_STORM,$(diffsym),$(packsym)

all: defscope lint

indent:
	$(WMLINDENT) .

defscope:
	$(DEFSCOPE) $(wildcard ./episode?/scenarios)

lint:
	$(WMLLINT) $(WESNOTH_CORE_DIR) $(targetdir)

test:
	@echo "Running preprocessor/parser test pass..."
	@echo "  Version:      $(WESNOTH_VERSION)"
	@echo "  Difficulties: $(difficulties)"
	@echo "  Episodes:     $(packs)"

	@for p in $(packs); do for d in $(difficulties); do \
		echo "    TEST    $$p -> $$d"; \
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines CAMPAIGN_AFTER_THE_STORM,$$d,$$p 2>&1 | tail -n +5 ; \
		rm -rf .preprocessor.out; \
	done; done

optipng:
	$(OPTIPNG)

clean:
	$(WMLLINT) --clean $(targetdir)
	find \( -name '*.new' -o -name '*.tmp' \) -type f -print | xargs rm -f
	rm -rf .preprocessor.out
