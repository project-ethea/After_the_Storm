# Run validation tests

ADDON_NAME           := After_the_Storm

CAMPAIGNSYM          := CAMPAIGN_AFTER_THE_STORM

DIST_VERSION_FILE    := dist/VERSION

DIFFICULTIES         := EASY NORMAL HARD
PACKS                := \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_I \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_II \
	CAMPAIGN_AFTER_THE_STORM_EPISODE_III

include ../Naia/tools/Makefile.wmltools

normalize-textdomains:
	find . \( -name '*.cfg' -o -name '*.lua' \) -type f -print0 | xargs -0 \
		sed -ri 's/wesnoth-(Invasion_from_the_Unknown|Era_of_Chaos)/wesnoth-After_the_Storm/'

clean: clean-wmltools
