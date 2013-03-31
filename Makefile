# Run validation tests

WESNOTH = wesnoth-1.10

WESNOTH_VERSION ?= $(shell $(WESNOTH) --version 2>&1 | tail -n 1)
WESNOTH_DATA_DIR ?= $(shell $(WESNOTH) --path 2>&1 | tail -n 1)
WESNOTH_CORE_DIR ?= $(WESNOTH_DATA_DIR)/data/core

DEFSCOPE ?= macro-scope-check
WMLLINT ?= wmllint-1.10
WMLINDENT ?= wmlindent-1.10
WMLXGETTEXT ?= wmlxgettext
OPTIPNG ?= wesnoth-optipng
WML_PREPROCESS ?= $(WESNOTH) -p

MAKEFLAGS += -rR --no-print-directory

# Internal variables

targetdir := $(realpath .)

difficulties := EASY NORMAL HARD
packs := \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_I \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_II \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_III

preprocesscmd = $(WML_PREPROCESS) $(targetdir) $(scratchdir) --preprocess-defines CAMPAIGN_AFTER_THE_STORM,$(diffsym),$(packsym)

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
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines __TEST_SUITE__,CAMPAIGN_AFTER_THE_STORM,$$d,$$p 2>&1 | tail -n +5 ; \
		rm -rf .preprocessor.out; \
	done; done

stats:
	@echo "Gathering WML statistics"
	@echo "  Version:      $(WESNOTH_VERSION)"
	@echo "  Difficulties: $(difficulties)"
	@echo "  Episodes:     $(packs)"

	@for p in $(packs); do for d in $(difficulties); do \
		echo "    WML     $$p -> $$d"; \
		$(WML_PREPROCESS) $(targetdir) .preprocessor.out --preprocess-defines __TEST_SUITE__,CAMPAIGN_AFTER_THE_STORM,$$d,$$p 2>&1 2> /dev/null; \
		wc -l .preprocessor.out/_main.cfg | sed -E 's/^([0-9]+).*/            \1 lines/'; \
		rm -rf .preprocessor.out; \
	done; done

optipng:
	$(OPTIPNG)

%.pot:
	@echo "    POT     $*.pot"
	@find \( -name '*.cfg' -o -name '*.lua' \) -type f -print | xargs wmlxgettext --directory=$(targetdir) --domain $(textdomain) > $*.pot
	@msgfmt --statistics -o /dev/null $*.pot 2>&1 | sed -E 's/^.*\s([0-9]+)\s.*$$/            \1 strings/'

pot: $(textdomain).pot

clean:
	$(WMLLINT) --clean $(targetdir)
	find \( -name '*.new' -o -name '*.tmp' -o -name '*.pot' -o -name '*.orig' -o -name '*.rej' \) -type f -print | xargs rm -f
	rm -rf .preprocessor.out
