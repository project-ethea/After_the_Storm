# Run validation tests

WESNOTH = wesnoth-1.12

WESNOTH_VERSION ?= $(shell $(WESNOTH) --version 2>&1 | tail -n 1)
WESNOTH_DATA_DIR ?= $(shell $(WESNOTH) --path 2>&1 | tail -n 1)
WESNOTH_CORE_DIR ?= $(WESNOTH_DATA_DIR)/data/core

DEFSCOPE ?= macro-scope-check
WMLLINT ?= wmllint-1.12 -d
WMLINDENT ?= wmlindent-1.12
WMLXGETTEXT ?= wmlxgettext
OPTIPNG ?= wesnoth-optipng
WML_PREPROCESS ?= $(WESNOTH) -p

MAKEFLAGS += -rR --no-print-directory

# Internal variables

targetdir := $(realpath .)

campaignsym := CAMPAIGN_AFTER_THE_STORM

difficulties := EASY NORMAL HARD
packs := \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_I \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_II \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_III

extrasyms := __TEST_SUITE__

textdomain = wesnoth-After_the_Storm

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
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines $(extrasyms),$(campaignsym),$$d,$$p 2>&1 | tail -n +5 ; \
		rm -rf .preprocessor.out; \
	done; done

stats:
	@echo "Gathering WML statistics"
	@echo "  Version:      $(WESNOTH_VERSION)"
	@echo "  Difficulties: $(difficulties)"
	@echo "  Episodes:     $(packs)"

	@for p in $(packs); do for d in $(difficulties); do \
		echo "    WML     $$p -> $$d"; \
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines $(extrasyms),$(campaignsym),$$d,$$p 2>&1 2> /dev/null; \
		wc -lcm .preprocessor.out/_main.cfg | awk '{printf "            %u lines, %u characters (%1.0f KiB)\n", $$1, $$2, $$3 / 1024}'; \
		rm -rf .preprocessor.out; \
	done; done

optipng:
	$(OPTIPNG)

%.pot:
	@echo "    POT     $*.pot"
	@find \( -name '*.cfg' -o -name '*.lua' \) -type f -print | xargs wmlxgettext --directory=$(targetdir) --domain $(textdomain) > $*.pot
	@msgfmt --statistics -o /dev/null $*.pot 2>&1 | sed -E 's/^.*\s([0-9]+)\s.*$$/            \1 strings/'

pot: $(textdomain).pot

normalize-textdomains:
	find \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 \
		sed -ri 's/wesnoth-(wesnoth-Invasion_from_the_Unknown|Era_of_Chaos)/wesnoth-After_the_Storm/'

clean:
	$(WMLLINT) --clean $(targetdir)
	find \( -name '*.new' -o -name '*.tmp' -o -name '*.pot' -o -name '*.orig' -o -name '*.rej' -o -name '*.map.cfg' \) -type f -print | xargs rm -f
	rm -rf .preprocessor.out
