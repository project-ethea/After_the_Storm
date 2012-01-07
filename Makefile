# Run validation tests

WESNOTH_DATA_DIR ?= $(shell wesnoth --path 2>&1 | tail -n 1)
WESNOTH_CORE_DIR ?= $(WESNOTH_DATA_DIR)/data/core

DEFSCOPE ?= macro-scope-check
WMLLINT ?= wmllint
WMLINDENT ?= wmlindent

MAKEFLAGS += -rR --no-print-directory

all: defscope lint

indent:
	$(WMLINDENT) .

defscope:
	$(DEFSCOPE) $(wildcard ./episode?/scenarios)

lint:
	$(WMLLINT) $(WESNOTH_CORE_DIR) $(realpath .)

clean:
	$(WMLLINT) --clean $(realpath .)
