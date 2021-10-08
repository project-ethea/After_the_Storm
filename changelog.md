After the Storm - Changelog
===========================

Version 0.11.0-dev:
-------------------
* General:
  * First fully-supported Wesnoth 1.16 release, supporting Wesnoth 1.15.14 and
    later.
  * Removed all compatibility code for Wesnoth 1.15.13 and earlier.

* Scenarios:
  * Cosmetic changes to scenario maps: E1S9.2, E1S9.3, E1S13, E2S0, E3S0.1,
    E3S7A.1F1, E3S7A.1F2, E3S7A.2, E3S8A.1, E3S8A.2, E3S8C, E3S9F1, E3S9F2,
    E3S9F3, E3S10, E3S11F4, E3S12, E3S7B, E3S8B, E3S13, E1S11.2, E1S12,
    E1S11.1, E1S1, E1S3, E1S7, E2S2, E2S5, E2S9, E2S10, E2S11, E2S3.2.

* Units:
  * Switched all units, abilities, and weapon specials to the 1.16 special
    notes syntax.


Version 0.10.18:
----------------
* General:
  * Update to Naia 20211005.

* Language and i18n:
  * Updated translations: French, Russian.

* Scenarios:
  * Replaced Fire Guardian summoning with Fire Wraith summoning for an
    extra-crispy sensation.
  * E3S10 - Blood:
    * Changed Blood Core buffs to use `[object]` in order to fix an issue with
      them being purged by subsequent unit rebuilds.
    * Minor boss fight adjustments.

* Units:
  * Use the Wesnoth 1.15.3 implementation of the Daze weapon special on
    Wesnoth 1.16. This should fix an issue where one of the player characters
    may get buried under a pile of auxiliary Daze `[object]` modifiers in late
    Episode 3 scenarios.
  * Lumeril Glyph is now a Monster unit with the Elemental trait.


Version 0.10.17:
----------------
* Scenarios:
  * Fixed Fire Guardian summoning to account for Fire Wraiths in Wesnoth
    1.15.14 and later, including both event filtering fixes and balance changes
    to the innate buff for the summons.

* Units:
  * Increased Lumeril Guard's melee attack from 14-3 to 16-3.
  * Increased Lumeril Guard's ranged attack from 11-2 to 12-2.


Version 0.10.16:
----------------
* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * E3S6 - Divergence:
    * Fixed Elynia saying good night after triggering a different dialogue if
      she is moved straight away from Anya to another character.
    * Fixed Igor becoming impossible to interact with after talking to Anya.


Version 0.10.15:
----------------
* General:
  * Update to Naia 20210430.

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * E3S11 - After the Storm:
    * Fixed Lua error on Wesnoth 1.15.13 and later.

* Units:
  * Enabled random name generation for Verlissh components for new
    playthroughs.


Version 0.10.14:
----------------
* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * E3S7B - Dark Sea:
    * Fixed a rare bug where the player defeating all enemies before turn 10
      would result in early victory and incorrect player configuration for
      subsequent scenarios.
  * E3S8B - Destiny, part 1:
    * Fixed Igor ending up stuck outside the boss room.

* Units:
  * Reworked the implementation of Elynia's animations used in the E1S6.1 and
    E2S8 cutscenes so her regular playable unit type is used instead of a
    cutscene-specific dummy.


Version 0.10.13:
----------------
* General:
  * Dropped support for Wesnoth versions 1.15.4 through 1.15.11.
  * Update to Naia 20210430.

* Graphics:
  * New or updated unit graphics: Elvish Avatar.

* Language and i18n:
  * Updated translations: French, Russian.

* Scenarios:
  * Made it so map labels are removed before specific cutscenes.
  * E1S1 - The Skirmish:
    * Igor can no longer smuggle items from IftU S21 through S24 into AtS.
  * E1S3 - Civil War in the North:
    * Fixed Igor not teleporting along with the other heroes at the start.
  * E3S8B - Destiny, part 1:
    * Fixed Igor's presence triggering a BUG condition.
  * E3S11 - After the Storm:
    * Igor now shows up in the cutscene if he is still alive at this point.

* Units:
  * New unit type descriptions: Naiad.
  * Demon Messenger, Demon Spelldancer, Demon Stormtide, Demon Hellbent Tide,
    Demon Slashing Gale, and Errant Executor can now receive the Fearless
    trait.


Version 0.10.12:
----------------
* General:
  * Update to Naia 20210401.

* Language and i18n:
  * Updated translations: French, Russian.

* Scenarios:
  * Reintroduced Igor from IftU, available on E1S1 if he's alive at the
    beginning of IftU S24.
  * E1S11.2 - Return to Wesmere, part 2:
    * Fixed multiple dumb logic issues involving a faerie.
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Force Nar-hamoth to flee if the player kills both enemy leaders first.
  * E3S8A - Interim:
    * Fixed incorrect object interaction with a brazier.
  * E3S11 - After the Storm:
    * Fixed a timing issue causing double text fade-out on Wesnoth 1.15.x.

* Units:
  * Units with the aqueous ability have any non-arcane resistances lower than
    10% raised to 10% (but not tripled) on applicable terrain.


Version 0.10.11:
----------------
* General:
  * Update to Naia 20200825.
  * Initial version with Wesnoth 1.16 (1.15.4) support (issue #71, Naia #4).

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Updated maps for the following scenarios not to use the deprecated Earthy
    Reinforced Cave Wall `Xuce` terrain, which does not have graphics of its
    own in 1.14 (it's effectively a duplicate of Mine Wall `Xuc`) and is slated
    to be removed in a future version: E1S7, E1S9.2, E1S9.3, E1S13, E3S1.
  * Made boss sides use the mainline `gold` color range instead of `yellow`
    (issue #73).
  * E1S9.1 - The Triad, part 1:
    * Give the player a greater sense of urgency.
  * E1S9.2 - The Triad, part 2:
    * Re-done terrain substitution mask for the final cutscene, as well as
      minor changes to unit positioning and debris placement.
  * E2S11 - A Final Confrontation:
    * Fixed a bug where Elynia's temporary item given to her for story
      progression would carry over into the next scenario (and E3 by proxy).
    * Fixed a bug where the boss fight sequence caused Lua errors on Easy
      difficulty during the Shaxthal spawn at the end of every boss side turn.
  * E3S2.1 - Return to Raelthyn:
    * The Fearless Faerie returns as a loyal unit here if she survives until
      the start of E1S11.2 and is not recalled there.


Version 0.10.10:
----------------
* General:
  * Update to Naia 20200816.


Version 0.10.9:
---------------
* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * E3S7B - Dark Sea:
    * Fix incorrect item check.


Version 0.10.8:
---------------
* General:
  * Update to Naia 20200814.
  * Moved part of the segmented scenario implementation to Lua.

* Scenarios:
  * E3S8A - Interim:
    * Minor UI/cutscene tweaks.
  * E3S11 - After the Storm:
    * Substantial code refactoring.
  * E3S12 - Destiny, part 3:
    * Minor UI/cutscene tweaks.
  * E3S13 - Epilogue:
    * Minor UI/cutscene tweaks.


Version 0.10.7:
---------------
* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Removed no-op `attack_depth` AI aspect.
  * E1S3 - Civil War in the North:
    * Made scenario objectives dummy-proof.
  * E3S10 - Blood:
    * Fixed wrong unit speaking in a rare event.
    * Implemented proper flooding logic for late sequences.
    * Minor balancing changes.

* Units:
  * Fixed spoiler unit being unexpectedly available in units.w.o listings.
  * The abattoir and shockwave weapon specials now play defense animations for
    units affected by splash damage (using `[harm_multiple_units]`).


Version 0.10.6:
---------------
* General:
  * Update to Naia 20200808.

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Updated maps for the following scenarios to use (or not use) the sconce
    terrain overlay instead of the Lit Stone Wall terrain deprecated in 1.16:
    E1S9.1, E1S9.2, E1S9.3, E1S11.2, E1S13, E2S0, E2S9, E2S10, E2S11, E3S4.1,
    E3S7A.1F1, E1S7A.1F2, E3S8C (issue #82).
  * E1S5 - Bay of Tirigaz:
    * Fixed animation issues with enemy flags.
  * E2S9 - New Hive:
    * Aesthetic and balancing tweaks to the map.
    * Added water drip sound sources.
  * E2S10 - The Betrayal:
    * Aesthetic and balancing tweaks to the map.
    * Added water drip sound sources.
    * Made more punishing on the player's economy by reducing the number of
      villages available and not adding initial gold on top of E2S9's 100%
      carryover (issue #80).
  * E2S11 - A Final Confrontation:
    * Added water drip sound sources.
    * Fixed Elynia being able to attack while incapacitated.
    * Minor animation tweaks.
    * Several balancing changes to make the boss fight somewhat more difficult
      on top of the overall E2 (and especially E2S9 and E2S10) balancing
      changes in this release (issue #80).
  * E3S4.1 - Outpost of Hell:
    * Fixed minor inconsistencies in the handling of terrain destruction when
      deploying charges around the main keep, making it so the stone wall tiles
      cannot be destroyed. It is intentionally still possible to leave passable
      castle tiles around for use during the boss fight.
  * E3S7B - Dark Sea:
    * The player is no longer allowed to recruit Dark Adepts for the remainder
      of the campaign.
  * E3S8A - Interim:
    * Implemented a workaround for mainline issue #3443 (see also IftU #28)
      affecting a lore glyph.
    * Minor map changes.
  * E3S8C - Breakdown:
    * Increase turn limit.
    * Don't bind a hotkey for the Summon Fire Guardian menu item since it gives
      the game engine an existential crisis when switching scenarios in the
      same session.
    * Fixed an incorrect terrain reference in a terraforming code path (related
      to issue #82).
  * E3S10 - Blood:
    * Fixed implementation details of the final boss demanding upkeep when they
      are not supposed to.
    * Minor cutscene fixes revolving around unit statuses.

* Terrains:
  * Added Blood Ford.

* Units:
  * Enable Troll Whelp → Troll Shaman unit progression for new runs.
  * Fixed units with the demolition ability becoming visible again after
    playing their death animation if other units get caught within the
    explosion radius.
  * Reduced Shaxthal Deathbringer's HP from 181 to 172.
  * Increased Faerie Avatar's HP from 77 to 93.
  * Increased Shaxthal Infiltrator's HP from 77 to 103.
  * Increased Shaxthal Infiltrator's arcane resistance from -10% to 0%.
  * Increased Shaxthal Stormblade Ivyel's HP from 67 to 73.
  * Fixed seismic weapon special not triggering when the unit possessing it
    hits another unit in retaliation.
  * Fixed seismic weapon special applying the stunned effect exactly once per
    scenario.
  * Fixed seismic weapon special not actually being limited to proccing once a
    turn only.
  * Made Shaxthal Demolisher Drone and Shaxthal Deathbringer immune to splash
    damage from the abattoir and shockwave weapon specials.


Version 0.10.5:
---------------
* Units:
  * Fixed stun weapon special working exactly once per scenario.


Version 0.10.4:
---------------
* General:
  * Update to Naia 20200724.1.

* Language and i18n:
  * Updated translations: Russian.

* Scenarios:
  * Fixed an issue where Irylean's Walking Corpses would start under 100% HP if
    a variation with a greater base HP than the base Walking Corpse was
    selected.


Version 0.10.3:
---------------
* General:
  * Update to Naia 20200724.
  * Replaced deprecated Lua API calls.

* Graphics:
  * New or updated unit graphics: Naiad, Ixthala Fire Dancer.

* Scenarios:
  * Cosmetic changes to the maps for the following scenarios: E1S1, E1S2,
    E1S3, E1S4, E1S5, E1S8, E3S7B, E3S6, E1S6.1, E1S6.2, E1S7x, E1S10,
    E1S11.1, E1S11x, E2S3.1, E3S2.1, E3S2.2, E1S9.2, E2S0, E3S7A.1F1,
    E3S7A.1F2, E3S8B, E3S8D, E3S11F2, E2S1, E2S2, E2S4, E2S5, E2S5x, E2S6,
    E2S7, E2S8, E2S12, E2S9, E2S10, E2S11, E3S3, E3S4.1, E3S5, E3S8C, E3S9F1,
    E3S9F2, E3S9F3, E3S12, E3S13.
  * E1S5 - Bay of Tirigaz:
    * ???
  * E1S7 - The Search for the Past:
    * Fix a minor prose inconsistency resulting from IftU 2.0.
  * E1S12 - The Queen:
    * Fixed minor map inconsistencies in the last segment.
  * E2S4 - Shifting Allegiances:
    * Zynara can only control a limited number of Ghost line units at a time,
      depending on campaign difficulty.
    * Zynara can no longer recruit Vampire Bats.
  * E2S7 - Proximus:
    * The player is no longer allowed to recruit Ghosts for the remainder of
      the campaign. Vampire Bats become available again to compensate.
  * E2S10 - The Betrayal:
    * ???
  * E3S2.1 - Return to Raelthyn:
    * Irylean can only recruit animal-type Walking Corpse variations
      (randomized per recruit).
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Minor balancing tweaks.
  * E3S6 - Divergence:
    * Made dialog choices replay-safe.
  * E3S7B - Dark Sea:
    * ???
    * Minor balancing tweaks.
  * E3S8B - Destiny, part 1:
    * Added a lesser wall of text.
  * E3S8D - Destiny, part 2:
    * Added more enemy guardians.
    * Added more water.
    * Implemented a workaround for a long-standing issue with objectives
      refresh for human-controlled sides caused by save-reloading.
  * E3S9 - Dark Depths:
    * Reduced Engineer's unit buff from +110% HP to +60% HP and +5 ranged
      damage to +4 ranged damage.
  * E3S10 - Blood:
    * Made menu item not execute in a synced context since it does not alter
      the game state in any way whatsoever.

* Terrains:
  * Fixed some technical terrains being available in the Help browser.
  * Added Dry Elven Castle Ruins.

* Units:
  * Fixed shockwave and abattoir weapon specials triggering when the unit
    possessing them is hit by attacks by AI units rather than when hitting
    them in retaliation.
  * Fixed shockwave and abattoir not attributing splash damage deaths to the
    attacker (for future code or external mods that may make this a relevant
    concern). They still do not attribute splash damage dealt otherwise due to
    a technical limitation in `[harm_unit]`, however.
  * Increased Ixthala Fire Dancer's level from 2 to 3.
  * Increased Ixthala Fire Dancer's HP from 40 to 60.
  * Increased Ixthala Fire Dancer's melee damage from 8-4 to 12-4.
  * Increased Demoness Slashing Gale's HP from 78 to 85.
  * Increased Demoness Slashing Gale's arcane resistance from -20% to -10%.
  * Increased Demoness Slashing Gale's impact resistance from 0% to 10%.
  * Increased Demoness Slashing Gale's ranged attack from 9-4 to 11-5.
  * Replaced Demoness Slashing Gale's ranged attack drains special with
    magical+slow.
  * Increased Demoness Slashing Gale's blade melee attack from 10-3 to 11-3.
  * Added drains weapon special to Demoness Slashing Gale's blade melee attack.
  * Added 11-2 melee impact attack with charge to Demoness Slashing Gale.
  * Reduced Magnum Suit's HP from 220 to 190.
  * Reduced Magnum Suit's melee attack from 22-2 to 20-2.
  * Reduced Magnum Suit's ranged attack from 11-14 to 10-10.
  * Disabled Shadow Angel AMLA due to issues with pathfinding glitches and
    console spam.


Version 0.10.2:
---------------
* General:
  * Update to Naia 20200628.

* Scenarios:
  * E1S12 - The Queen:
    * Minor visual fix.
  * E3S1 - Beyond her Smile (A Light in the Darkness):
    * Minor UI fix.
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Fixed the Potion of Bloodlust being obtainable by the wrong units.


Version 0.10.1:
---------------
* General:
  * Update to Naia 20200625.
  * Fixed OOS errors caused by Naia's cutscene skip functionality, first
    introduced in version 0.10.0.

* Graphics:
  * Remove unused copies of the mainline trash/detritus/liter terrain overlay
    graphics that were supposed to be deleted in AtS 0.9.13.

* Scenarios:
  * Added a hint to the first playable scenario of each episode about
    browsing through unit AMLAs.
  * E1S7x - Resolutions:
    * Minor prose tweaks.
  * E2S5 - The Eastern Front:
    * Bow of Krysvelen item now adds to existing weapon specials instead of
      replacing them.
  * E3S7A - Dark Fire:
    * Poison Jar can now be used by the Saurian Skirmisher line and adds to
      existing weapon specials instead of replacing them.
  * E3S10 - Blood:
    * Minor UI tweaks.

* Terrains:
  * Updated Blood terrain to use the Wesnoth 1.14 water composition rules
    instead of a tinted version of the 1.10 animated water.

* Units:
  * Added missing sidebar status icon for the dazed weapon special effect.
  * Double-killed Kri'tan.


Version 0.10.0:
---------------
* General:
  * First Wesnoth 1.14.x release, raising the minimum version requirement to
    Wesnoth 1.14.3 (Wesnoth 1.15.x is *not* supported yet). Some large chunks
    of code (in particular FOREACH loops) were rewritten in the process.
  * Dropped workaround for Debian bug #782831/#780853 in libvorbis (also known
    as Wesnoth Gna.org bugs #23633 and #23599).
  * Replaced map_data with map_file to load scenario maps.
  * Shared units, assets, code, and translations are now part of the Naia
    library, also used by IftU version 2.1.0 and later.
  * Update to Naia 20200621.
  * Updated art licenses for CC BY-NC-ND 4.0, CC BY-SA 4.0 and CC0 content.

* Graphics:
  * New or updated unit graphics: Shaxthal Hive Queen, Gatekeeper, Angel of
    Blood, Blood Core.

* Language and i18n:
  * Updated translations: French (WIP), Japanese (WIP), Russian (WIP).

* Scenarios:
  * E1S4 - Terror at Dusk:
    * Added Obsidian Battle Axe item.
  * E1S7 - The Search for the Past:
    * Added Vial of Fire Essence item.
    * Disabled early-finish bonus and removed a few villages.
    * Various prose revisions.
  * E1S8 - Fear:
    * Minor cutscene tweaks.
  * E1S9.3 - The Triad, part 3:
    * Fix a unit animation not playing any sounds in a cutscene at the end of
      the scenario.
  * E1S12 - The Queen:
    * Various tweaks to the boss fight and Shaxthal Hive Queen unit type for
      balancing purposes.
  * E2S4 - Shifting Allegiances:
    * Added Amber Ward item.
  * E2S5 - The Eastern Front:
    * Added Bow of Krysvelen item.
  * E2S6 - The Voyage Home:
    * Fix scrolling to speaking units not working at the start of sandstorms.
  * E2S8 - And then there was Chaos:
    * Minor balancing tweaks.
  * E2S9 - New Hive:
    * Minor balancing tweaks.
  * E2S11 - A Final Confrontation:
    * Minor balancing tweaks.
  * E3S2.1 - Return to Raelthyn:
    * Fixed Torancyn speaking right before the last payload is destroyed rather
      than right afterwards (issue #51).
    * Fixed objectives continuing to list the destruction of Adavyan’s keep as
      a defeat condition after all payloads have been destroyed (issue #51).
    * Minor balancing tweaks.
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Added Obsidian Battle Axe item.
    * Added Potion of Bloodlust item.
    * Fixed Nar-hamoth costing upkeep to his side.
    * Reworked Nar-hamoth mini-boss sequence (issue #53).
  * E3S4.1 - Outpost of Hell:
    * Added Ring of Quicksilver item.
    * Fixed a rare case where a unit that is expected to generate death events
      such as the main characters could sit on top of primed charges before
      ending their turn and then get killed without consequences (unless they
      were Elynia or General Bardyl).
    * Minor balancing tweaks.
  * E3S4.2 - Gateway:
    * Fix Kyara and Horo being killed prematurely and having their stats reset
      at the start of the cutscene as a result (issue #58).
  * E3S5 - Pass of Sorrows:
    * Added Vial of Shardia's Tears item.
    * Added Staff of Akhlys item.
    * Minor balancing changes.
  * E3S6 - Divergence:
    * Use the polluted environment version of the ToD schedule.
  * E3S7A - Dark Fire:
    * Fix dialogue typo in part 2 reported by Inky.
  * E3S7B - Dark Sea:
    * Use the polluted environment version of the ToD schedule.
    * Avoid spawning allies in impassable locations (issue #59).
  * E3S8A - Interim:
    * Made an item easier to find.
    * Fix dialogue typo reported by Inky.
    * Cosmetic changes.
  * E3S8B - Destiny, Part 1:
    * Ensure the player has enough gold to recall units in the boss arena.
    * Minor balancing changes.
  * E3S8C - Breakdown:
    * Fix an error rendering this scenario uncompletable.
    * Minor cutscene tweaks (issue #64, #65).
  * E3S8D - Destiny, Part 2:
    * Fix an issue where Ergea might announce more than once that either the
      Iron Council or the Storm Sisters have yet to be defeated (reported by
      Inky).
    * Gave the swarm team a unique team color instead of a default-constructed
      one that produces inconsistent results on 1.14.
  * E3S9 - Dark Depths:
    * Various balancing changes to boss fights.
  * E3S10 - Blood:
    * Added a couple of optional walls of text for people who somehow believe
      my campaign didn't already have enough walls of text before.
    * Fully reworked boss fight. Hahaha Wesnoth attack prediction code go
      brrrrrrrrr.

* Units:
  * Decreased Elynia's initial maximum XP from 150 to 64.
  * Revised Elynia's AMLA tree and made upgrades persist throughout the entire
    set of campaigns:
    * Strength:
      * Strength I: HP +4, melee dmg +1
      * Strength II: HP +4, melee str +1
      * Strength III: HP +5
      * Strength IV (E2): HP +5, melee dmg +1
      * Strength V (E2): HP +7
    * Focus:
      * Focus I: ensnare str +1
      * Focus II: ensnare dmg +1 str +1
      * Focus III (E2): ensnare dmg +1
      * Focus IV (E2): ensnare dmg +1, stun weapon special
    * Shielding (requires Focus I):
      * Shielding I: arcane res +10%
      * Shielding II: impact res +10%
      * Shielding III (E2): cold res +10%, sylvan essence regen +1
      * Shielding IV (E3): fire res +10%
      * Shielding V (E3): protection ability
    * Thorns:
      * Thorns I: thorns dmg +2
      * Thorns II: thorns dmg +2, drains weapon special
    * Faerie Fire (requires Focus II, Strength II):
      * Faerie Fire I: replaces mystic fire, ranged/arcane 9-3 magical
      * Faerie Fire II (E2): faerie fire dmg +1
      * Faerie Fire III (E2): faerie fire str +1
      * Faerie Fire IV (E3) (req. Focus III, Shielding III, Strength III):
        faerie fire dmg +1
      * Faerie Fire V (E3) (req. Focus IV, Shielding IV, Strength IV):
        faerie fire dmg +1
  * Decreased Galas' initial maximum XP from 150 to 80.
  * Revised Galas' AMLA tree:
    * Stealth: adds ambush ability
    * Hunter:
      * Hunter I: add bolas, ranged/impact 9-2 slows
      * Hunter II: bolas str +1
    * Strength:
      * Strength I: melee dmg +1
      * Strength II: HP +4, melee str +1
      * Strength III: HP +5
    * Strength III-dependent upgrades:
      * Fury (exclusive with Initiative): melee berserker weapon special
      * Initiative (exclusive with Fury): melee first strike weapon special
    * Armor:
      * Armor I: blade res +10%, pierce res +10%
      * Armor II: impact res +10%
      * Armor III: blade res +10%
  * Decreased Anya's initial maximum XP at level 3 from 150 to 73.
  * Revised Anya's AMLA tree:
    * Strength:
      * Strength I: melee dmg +1
      * Strength II: HP +4, melee dmg +1
      * Strength III (E3): HP +4, melee str +1
      * Strength IV (E3): melee drains weapon special
    * Focus:
      * Focus I: noctum dmg +1
      * Focus II: forest chill dmg +1, daze weapon special
      * Focus III (E3): forest chill str +1
      * Focus IV (E3): noctum dmg +1
      * Focus V (E3) (req. Strength IV): noctum dmg +1, str +1
    * Shielding:
      * Shielding I: fire res +10%
      * Shielding II: fire res +10%, cold res +10%
      * Shielding III (E3): arcane res +10%
    * Evasion (E3) (requires Strength II, Focus II): adds abscond ability
  * Increased Elyssa's arcane resistance from -10% to 0%.
  * Increased Shaxthal Custodian Drone's HP from 79 to 88.
  * Increased Shaxthal Custodian Drone's fire ranged attack from 5-14 to 7-14.
  * Increased Shaxthal Custodian Drone's impact ranged attack from 12-4 to 13-4.
  * Increased Shaxthal Warlord Nar-hamoth's HP from 91 to 99 and gave him the
    steadfast ability.
  * Increased Shaxthal Warlord Nar-hamoth's arcane resistance from -10% to 0%.
  * Increased Shaxthal Warlord Nar-hamoth's melee attack from 14-3 to 15-3 and
    gave it the shock special.
  * Increased Shaxthal Warlord Nar-hamoth's ranged attack from 9-3 to 10-3 and
    gave it the drains special.
  * Increased Shaxthal Warlord Elyssa's HP from 94 to 145.
  * Increased Lumeril Guard and Lumeril Glyph Mistress' arcane resistance from
    -10% to 0%.
  * Increased Lumeril Glyph Mistress' HP from 106 to 114.
  * Increased Lumeril Glyph's arcane resistance from -50% to -30%.
  * Increased Lumeril Glyph's HP from 77 to 99 and gave it the regenerates
    ability.
  * Increased Magnum Suit's melee attack from 21-2 to 22-2 and gave it the
    seismic special.
  * Increased Magnum Suit's ranged attack from 19-3 to 11-14 and gave it the
    swarm and marksman weapon specials.
  * Gave leadership to Magnum Suit.
  * Increased Demoness Spelldancer's HP from 42 to 53 and gave her the
    leadership ability.
  * Increased Valdemon Basher's HP from 52 to 57.
  * Increased Serpent Messenger's HP from 63 to 66.
  * Increased Shaxthal Deathbringer Alpha's arcane resistance from -10% to 10%.
  * Gave terror and leadership to Shaxthal Deathbringer Alpha.
  * Increased Shaxthal Deathbringer Alpha's melee attack from 22-2 to 24-2.
  * Increased Shaxthal Deathbringer Alpha's arcane ranged attack from 11-6 to
    13-6.
  * Complete rework of the Angel of Blood and Blood Core units.
  * Added combat stats to the standard Shaxthal Deathbringer.
  * Physical endurance no longer protects against cold and fire damage.
  * Replaced classic Quenoth elves with their 1.14 versions. As a side-effect
    of this, Kyara is now a mounted level 2 Quenoth Archer.
  * Removed unused unit types: Elvish Civilian.
  * New unit type descriptions: Chaos Cataphract, Hound of Chaos, Demonic
    Hound, Hellhound.
  * Enabled Orcish Nightblade advancement from Orcish Slayer.
  * Chaos Cardinal migrated to Naia and expanded with a new baseframe by VYNLT
    and slightly different stats over the mainline Ancient Lich:
  * Fixed Chaos Sharpshooter not having an AMLA.
  * Fixed Magnum Suit's ranged attack dealing impact instead of fire damage,
    increased from 15-3 to 19-3.
  * The Stun effect is now cleared off affected units at the end of the
    controlling side's turn rather than at the start.
  * Chaos Hound line is now considered part of the wolves race and receives
    names and traits accordingly.
  * Terror ability no longer affects same-level units.
  * Demolition ability's AoE no longer crosses through cave walls, chasms, and
    other impassable or unwalkable terrains.
  * Fixed issue where Demolition could turn water into dirt.


Version 0.9.17:
---------------
* Graphics:
  * New or updated unit graphics: Chaos Headhunter, Chaos Marauder, Chaos
    Soulhunter, Anya, Uria, Elynia (E3 finale), Faerie Forest Spirit,
    Eventide Dancer, Domain Guard, Aradellys.
  * New or improved unit animations: Elynia (E1/E2 ranged attack, E1/E2
    defense, E3 melee, E3 ranged attack, E3 defense, E3 finale ranged attack,
    E3 finale melee attack, E3 finale defense).

* Language and i18n:
  * Updated translations: Japanese.

* Music:
  * The IftU Music add-on is now required in addition to AtS Music, and the
    tracks already provided by it have been removed from AtS Music.

* Scenarios:
  * E1S3 - Civil War:
    * Dialogue typo fix by Inky.
  * E1S10 - Tears:
    * Story text typo fix by Inky.
  * E2S12 - Fate:
    * Replaced the beginning of a pivotal line by Elynia with a rephrased
      version provided by vultraz (from IftU 2.0.1).
  * E3S1 - Beyond her Smile (A Light in the Darkness):
    * Story text typo fix by Inky.
  * E3S9 - Dark Depths:
    * Added full ending cutscene.
    * Minor prose fixes for the ending cutscene.

* Units:
  * New unit type descriptions:
    * Chaos Arbalestier, Chaos Crossbowman, Chaos Invader, Chaos Bowman, Chaos
      Raider, Chaos Headhunter, Chaos Doom Guard, Chaos Hell Guardian, Chaos
      Dark Knight, Chaos Razerman, Shaxthal Drone, Chaos Invoker, Chaos Magus,
      Sylvan Warden, Chaos Lorekeeper, Chaos Marauder, Chaos Soulhunter, Chaos
      Warlord, Chaos Hound, Demonic Hound, Hellhound, Chaos Longbowman, Chaos
      Heavy Longbowman, Chaos Cavalier, Chaos Cataphract, Fungoid, Faerie
      Sprite, Fire Faerie, Faerie Dryad, Faerie Forest Spirit, Shaxthal
      Rayblade, Shaxthal Sentry Drone, Shaxthal Assault Drone, Minor Imp, Imp,
      Blood Imp, Gutwrencher Imp, Armageddon Imp.
  * Door units now clear terrain beneath them on 'last breath' rather than
    'die' events, in order to ensure shroud is correctly cleared before
    scenario-specific event handlers are run.
  * Replaced Chaos Crossbowman and Arbalestier's sword attack with an axe to
    match the sprites.


Version 0.9.16:
---------------
* Graphics:
  * New or updated unit graphics: Chaos Emperor.

* Scenarios:
  * E2S8 - And then there was Chaos:
    * Fixed Elynia disappearing from the map and causing issues if her HP goes
      below 1 during the same attack sequence that results in Ivyel fleeing.

* Units:
  * AMLAs:
    * Galas can now get the berserker special on melee attacks (requires
      Strength I).
  * Balancing:
    * Increased arcane resistance for mechanical units (Automaton, Iron Golem,
      Goliath) from 30% to 50%.
    * Increased Magnum Suit's arcane resistance from 40% to 50%.


Version 0.9.15:
---------------
* Graphics:
  * New or improved unit animations: Elynia (E1/E2 melee attack).
  * New or updated unit graphics: Fallen Faerie.
  * Fixed Elynia's fire attack having no sound effects in E1 and E2.


Version 0.9.14:
---------------
* General:
  * A work-in-progress version was uploaded to the add-ons server as 0.9.13 by
    mistake. In order to avoid confusion and ensure automated upgrades work
    correctly, the final release number is 0.9.14.

* Graphics:
  * New or updated terrain graphics: Dark Hive, Dark Hive Surface, Dark Hive
    Depths.
  * New attack icon for Elynia's staff.
  * New or improved unit animations: Elynia (E1/E2 defense, ranged attack).

* Language and i18n:
  * New translations: Japanese.

* Scenarios:
  * E3S7A - Dark Fire:
    * Fixed the Potion of Life being able to be picked up multiple times.

* Terrains:
  * Added Wall Moss terrain overlay.
  * Removed custom campfire terrain (phased out in 0.9.12).
  * Removed custom trash/remains terrains (phased out in 0.9.12).

* Units:
  * Added a new unit type for Mal Hekuba.
  * Added a new unit type for the E2S11 boss.


Version 0.9.12:
---------------
* General:
  * Work around crashes related to music transitions during cutscenes under
    yet-to-be-determined operating conditions.
  * Removed more Wesnoth 1.10.x support code.
  * Replaced empty ellipse images with the new ellipse=none syntax from
    version 1.11.11.

* Graphics:
  * Placeholder portraits added: Valen.

* Scenarios:
  * E1S3 - Civil War in the North:
    * Give the player standard gold carryover, no bonus.
  * E2S0 - Transience:
    * Fixed sound effects remaining muted when advancing to the next scenario.
  * E2S1 - By the Moonlight:
    * Uncover Elynia at the start of the first town dialogue sequence, in case
      she is standing in forest tiles.
  * E2S10 - The Betrayal:
    * Major map tweaks past the central gates.
    * Reduced turn limit from 88/86/84 to 62/60/58.
  * E2S11 - A Final Confrontation:
    * Fixed a regression from 0.9.9 causing the boss keep to gradually crumble
      down, potentially killing it prematurely.
  * E3S4.1 - Outpost of Hell:
    * Allow two more charges to spawn on the initial player bases on Hard,
      thus matching the number of charges available on other difficulty levels.
    * Reduced bonus enemy gold on turn 10 and added a heads-up for the player.
  * E3S7B - Dark Sea:
    * Fixed (again) a bug with Anya's ellipse assignment.
    * Minor difficulty tweaks.
  * E3S8C - Breakdown:
    * Assigned a default hotkey for the elemental summoning menu option.

* Terrains:
  * Replaced custom campfire terrain with its mainline equivalent (^Zi → ^Ecf),
    losing its +25% lawful bonus in the process.
  * Replaced custom trash/remains terrains with their mainline equivalents
    (^Ettz → ^Edt, ^Etbz → ^Edb).


Version 0.9.11:
---------------
* General:
  * Work around bug in Wesnoth 1.11.17 that could cause units to be deleted
    from the game by units moving during cutscenes.


Version 0.9.10:
---------------
* General:
  * Raised minimum game version requirement to 1.11.11. All existing
    compatibility code for previous versions has been removed.

* Graphics:
  * New or updated unit graphics: Sprite, Fire Faerie, Forest Spirit, Dryad,
    Demon Shapeshifter.

* Scenarios:
  * Added an option to certain scenarios to ensure Wesnoth does not discard
    the player's gold and recall list under certain circumstances due to a
    behavior change in version 1.11.13 and later. Affected scenarios:
    * E1S9.3 - The Triad, part 3
    * E1S11 - Return to Wesmere, part 2
    * E2S0 - Transience
    * E2S11 - A Final Confrontation
    * E3S0 - Opening (Within)
    * E3S6 - Divergence
    * E3S8B - Destiny, part 1
    * E3S11 - After the Storm

* Units:
  * Balancing changes:
    * Changed Leech's alignment from 'lawful' to 'neutral'.
    * Decreased Leech's HP from 62 to 42.
    * Decreased Leech's melee damage from 11-2 to 9-2.
    * Decreased Leech's unit level from 3 to 1.
  * Converted to the simplified 1.12 animation syntax:
    * Dusk Faerie, Night Nymph, Nightshade Fire
    * Sylvan Warden
    * Sprite, Fire Faerie, Dryad, Forest Spirit
    * Elvish Wayfarer
    * Faerie Avatar
    * Demoness Hellbent Tide
    * Verlissh Control Spire

* User interface:
  * Cutscene themes now use the 1.11.10 [theme] id attribute on 1.11.10 and
    later.


Version 0.9.9:
--------------
* General:
  * Removed Wesnoth development versions warning from the campaign menu entries
    as support for 1.11.8 and later is now mature.
  * New complete algorithm for calculating the relative direction between two
    hex grid locations, handling all six intrinsic facing directions instead
    of only SW and SE.
  * Updated Aragwaith faction from Era of Chaos 1.3.1+dev up to commit
    9dedeba7cddc2a027745c9994a917fdcb78ed341.
  * Stripped optional whitespace from terrain map and mask files, decreasing
    uncompressed directory size by about 62%.

* Graphics:
  * New or updated unit graphics: Blood Core, multiple Aragwaith units, Demon
    Grunt.
  * Assigned a more dignified generic portrait to Cron (1.11.x only).

* Music and sound effects:
  * Mitigated [fade_out_music] causing a portion of the previous track to be
    heard at full volume at the end of the fade-out sequence. It still won't
    help in all cases.

* Scenarios:
  * Fixed additional bugs with hero ellipses on Wesnoth 1.11.6 and later
    affecting Anya on every scenario and Durvan on scenario E3S7B and later.
  * Use STARTING_VILLAGES_ALL instead of STARTING_VILLAGES with large numbers
    to assign all villages to sides.
  * Skip inclusion of death events for characters that are not present during
    the first few scenarios of E1.
  * E1S3 - Civil War in the North:
    * Fixed the first defined on-map unit (usually Galas) becoming permanently
      invisible.
    * Minor prose tweaks.
  * E1S4 - Terror at Dusk:
    * Balancing changes to make the scenario easier on Wesnoth 1.11.7 and
      later, possibly connected to the new AI recruitment gold saving aspect
      introduced in Wesnoth 1.11.7 and enabled by default.
    * Minor prose tweaks.
  * E1S5 - Bay of Tirigaz:
    * Made it so Mal Keshar speaks for bat units when investigating shipwrecks.
    * Minor map tweaks.
    * Minor prose tweaks.
  * E1S6.1 - Quenoth Isle:
    * Fixed Elynia's ellipse reverting to a generic unit ellipse on 1.11.x
      during the faerie fire cutscene.
    * Not-so-minor prose tweaks.
  * E1S6.2 - Elves of a Different Land:
    * Not-so-minor prose tweaks.
    * Extended map for large screens.
  * E1S7 - The Search for the Past:
    * Added cave ambience sound sources.
    * Improved ending cutscene transition.
    * Minor AI adjustments to make the undead minions recruit correctly on
      Wesnoth 1.11.7 and later.
    * Not-so-minor prose tweaks.
  * E1S7x - Resolutions:
    * Minor map tweaks.
    * Not-so-minor prose tweaks.
  * E1S8 - Fear:
    * Not-so-minor prose tweaks.
  * E1S9.1, E1S9.2, E1S9.3 - The Triad:
    * Added cave ambience sound sources.
    * Not-so-minor prose tweaks.
    * Various cutscene improvements and changes.
  * E1S10 - Tears:
    * Minor prose tweaks.
  * E1S11.1 - Return to Wesmere, part 1:
    * Not-so-minor prose tweaks.
  * E1S11.2 - Return to Wesmere, part 2:
    * Added cave ambience sound sources.
    * Fixed story text not appearing because of a missing macro inclusion
      (long-standing bug that's existed ever since the scenario was first
      released).
    * Minor map tweaks.
    * Minor prose tweaks.
  * E1S12 - The Queen:
    * Added cave ambience sound sources.
    * Balancing changes.
    * Excluded time area for the E1S11.2 starting area on Wesnoth 1.11.7 and
      earlier (including 1.10.x) due to a bug with time area ids not being
      saved, resulting in a time area with local lighting that interfers with a
      cutscene sequence after reloading from a non-start-of-scenario save.
    * Fixed long-standing offset-by-one bug with a terrain mask applied near
      the end.
    * Minor map tweaks.
    * Not-so-minor prose tweaks.
    * Various cutscene improvements and changes.
  * E1S13 - Death and Rebirth:
    * Minor cutscene improvements and changes.
  * E2S1 - By the Moonlight:
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Not-so-minor prose tweaks.
    * Now the scenario lives up to its name.
  * E2S2 - The Heart Forest:
    * Fixed fog not being cleared correctly when Allyna first appears.
    * Made it so Allyna introduces herself once three of the five bandits have
      been killed rather than all of them.
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Minor prose tweaks.
  * E2S3.1 - Unrest in Raelthyn:
    * Minor prose tweaks.
  * E2S3.2 - Revelations:
    * Minor prose tweaks.
  * E2S4 - Shifting Allegiances:
    * Minor prose tweaks.
  * E2S5 - The Eastern Front:
    * Minor prose tweaks.
  * E2S6 - The Voyage Home:
    * Not-so-minor prose tweaks.
  * E2S7 - The Voyage Home:
    * Minor prose tweaks.
  * E2S8 - And then there was Chaos:
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Not-so-minor prose tweaks.
  * E2S9 - New Hive:
    * Added cave ambience sound sources.
    * Minor prose tweaks.
  * E2S10 - The Betrayal:
    * Added cave ambience sound sources.
    * Minor prose tweaks.
  * E2S11 - A Final Confrontation:
    * Added cave ambience sound sources.
    * Maybe-minor prose tweaks.
    * Minor cutscene tweaks and improvements.
  * E2S12 - Fate:
    * Minor cutscene tweaks and improvements.
  * E3S0 - Opening (Within):
    * Added cave ambience sound sources.
    * Minor cutscene tweaks and improvements.
  * E3S1 - Beyond her Smile (A Light in the Darkness):
    * Minor map tweaks.
    * Various cutscene improvements and changes.
  * E3S2.1 - Return to Raelthyn:
    * Minor map tweaks.
    * Increased initial gold supply for the second human player side.
  * E3S2.2 - Reckoning:
    * Minor prose tweaks.
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Minor prose tweaks.
  * E3S4.1 - Outpost of Hell:
    * Minor prose tweaks.
  * E3S4.2 - Gateway:
    * Minor prose tweaks.
  * E3S5 - Pass of Sorrows:
    * Minor map tweaks.
    * Minor prose tweaks.
    * Minor ending cutscene improvements.
  * E3S6 - Divergence:
    * Minor prose tweaks.
  * E3S7A - Dark Fire:
    * Prevent crashing Wesnoth 1.11.8 due to a missing initial time of day
      (part 1 only).
    * Added cave ambience sound sources.
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Minor map tweaks.
    * Minor prose tweaks.
  * E3S7B - Dark Sea:
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Minor prose tweaks.
  * E3S8A - Interim:
    * Prevent crashing Wesnoth 1.11.8 due to a missing initial time of day.
    * Added cave ambience sound sources.
    * Minor cutscene improvements nobody could possibly notice.
    * Minor prose tweaks.
  * E3S8B - Destiny, part 1:
    * Minor aesthetic changes nobody could possibly notice.
    * Fixed parts of the map being unintentionally uncovered upon entering
      Hemérilyel's chamber.
    * Made Hemérilyel more aggressive towards the player on Wesnoth 1.11.2 and
      later.
  * E3S8C - Breakdown:
    * Added cave ambience sound sources.
    * Minor AI adjustments for Wesnoth 1.11.7 and later.
    * Minor prose tweaks.
  * E3S8D - Destiny, part 2:
    * Minor prose tweaks.
  * E3S9 - Dark Depths:
    * Added cave ambience sound sources.
    * Minor prose tweaks.
  * E3S10 - Blood:
    * Added cave ambience sound sources.
    * Minor prose tweaks.
  * E3S11 - After the Storm:
    * Minor prose tweaks.
  * E3S12 - Destiny, part 3:
    * Added cave ambience sound sources.
    * Minor prose tweaks.
  * E3S13 - Epilogue:
    * Minor prose tweaks.

* Units:
  * Balancing changes:
    * Imps are now immune to the plague weapon special.
    * The Protection ability affects own units of any lower level again instead
      of only level 0 and 1.
      * Affected units: Demoness Hellbent Tide, Aragwaith Shield Guard,
        Aragwaith Ancient Banner.
    * Physical endurance no longer resets statuses (poisoned, slowed, etc.).
    * Decreased Lumeril Glyph Mistress' arcane damage resistance from -10% to
      -20%.
    * Decreased Fallen Faerie's cold ranged attack strength from 11-3 to 10-3.
  * New or improved unit animations: Verlissh Matrix Core, Shaxthal Custodian
    Drone, Shaxthal Queen, Verlissh Matrix Flow System, Verlissh Control Spire,
    multiple Aragwaith units, Dusk Faerie line.
  * Made it so the Falcon unit type and the lightfly movetype are only defined
    if the mainline Khalifate faction is not present, by testing the existence
    of core/units/khalifate/Falcon.cfg.
  * Fixed a minor inaccuracy at the beginning of the Terror ability
    description.
  * The spawn controller code (used e.g. in Shaxthal hives) has been completely
    rewritten in Lua. No behavior changes expected.


Version 0.9.8:
--------------
* General:
  * Added a preload-time event to warn the player when attempting to use an
    unsupported Wesnoth version (< 1.9.10, < 1.10, = 1.11.0, = 1.11.1 at this
    time).

* Scenarios:
  * E1S1 - The Skirmish:
    * Minor prose tweaks.
  * E1S3 - Civil War in the North:
    * Minor map tweaks.
    * Minor prose tweaks.
  * E3S4.1 - Outpost of Hell:
    * Fixed a side-effect of the [hidden_unit] clobbering fix from 0.9.7 that
      renders the scenario unwinnable after killing the final enemy boss.

* Units:
  * Updated Chaos Gunner line animations for compatibility with Wesnoth 1.11.7.

* Terrains:
  * Added litter terrain overlay from doofus-01, not currently used yet.
    * Code: <http://r.wesnoth.org/p555984>
    * Graphics: <http://r.wesnoth.org/p556000>


Version 0.9.7:
--------------
* Scenarios:
  * E3S10 - Blood:
    * Fixed an oversight in the implementation of the [hidden_unit] WML action
      that could cause an event to destroy the player units forever by
      clobbering them with enemy units at the start of the second stage.

* Units:
  * Removed compatibility code introduced in version 0.9.4 to handle the
    'fairy'->'faerie' race id transition done in that same release. Saved games
    from 0.9.3 and older versions may not be used from now on.


Version 0.9.6:
--------------
* General:
  * The workaround for the [move_unit_fake]/[move_unit] interaction with
    [lock_view] is now used only for Wesnoth 1.11.0 through 1.11.5 since a
    superior solution is now built into version 1.11.6.

* Graphics:
  * New or updated unit graphics: Argan, Elyssa (E1/E2), Demon, Demon Zephyr,
    Demon Grunt, Demon Warrior, Demon Messenger, Demoness Spelldancer, Demon
    Stormtide, Demoness Hellbent Tide, Demoness Slashing Gale, Angel of Blood,
    Errant Executor, Gatekeeper.
  * Eliminate various missing image warnings caused by changes to the handling
    of custom unit ellipses for ZoC-less (e.g. L0) units in Wesnoth 1.11.6 and
    later.
  * Fixed issues with invisible L0/stunned unit ellipses on Wesnoth 1.11.6 and
    later.

* Scenarios:
  * E2S4 - Shifting Allegiances:
    * Fixed Tara's loyal icon overlay ending up assigned to a Rock Golem.
  * E3S4.1 - Outpost of Hell:
    * Mark "Defeat all enemy leaders" as an optional bonus objective as opposed
      to alternative.
  * E3S6 - Divergence:
    * Fix a severe gold management issue.

* Units:
  * New unit type descriptions:
    * Demon, Demon Zephyr, Demon Grunt, Demon Warrior
    * Demoness Messenger
    * Elvish Civilian
    * Elvish Hunter, Elvish Trapper, Elvish Prowler
    * Elvish Wayfarer
    * Dusk Faerie, Night Nymph, Nightshade Fire
    * Sylvan Warden
    * Civilian, Messenger
    * Animated Rock, Rock Golem.
  * Renamed Demon Spelldancer to Demoness Spelldancer (UI name only).
  * Renamed Demon Messenger to Demoness Messenger (UI name only).
  * Replaced Demon Lord unit type with the Errant Executor.


Version 0.9.5:
--------------
* Graphics:
  * New or updated unit graphics: Elynia (E3), Magnum Suit, Elyssa (E3), Ivyel,
    Allyna, E3S13 bystanders.

* Scenarios:
  * E1S2 - High Pass:
    * Added time over event.
  * E1S3 - Civil War in the North:
    * Fixed Unidë disappearing at the very beginning of her initial dialog with
      Galas at the end of the first turn of standard gameplay.
  * E1S4 - Terror at Dusk
    * Added time over event.
  * E1S9.1, E1S9.2, E1S9.3 - The Triad:
    * Added time over events.
  * E2S4 - Shifting Allegiances:
    * Added time over events.
  * E2S6 - The Voyage Home:
    * Added floating labels to indicate banished Errant Souls.
  * E2S9 - New Hive:
    * Added time over events.
  * E2S10 - The Betrayal:
    * Added time over events.


Version 0.9.4:
--------------
* General:
  * Solved "could not open image 'misc/ellipse-none-leader-*" errors on
    Wesnoth 1.11.5 and later, affecting certain cutscenes including but not
    limited to E2S12.

* Graphics:
  * New or updated unit graphics: Anya, Elynia.

* Scenarios:
  * E1S2 - High Pass:
    * Solve [target] deprecation warnings on Wesnoth 1.11.5 and later.
  * E1S4 - Terror at Dusk:
    * Updated map to use the ^Ftd palm forest terrain on Wesnoth 1.11.x instead
      of the denser ^Ft tropical forest.
  * E1S10 - Tears:
    * Solve [target] and protect_leader deprecation warnings on Wesnoth 1.11.5
      and later.
    * Updated map to use the ^Ftd palm forest terrain on Wesnoth 1.11.x instead
      of the denser ^Ft tropical forest.
  * E1S11.1 - Return to Wesmere, part 1:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.
  * E2S1 - By the Moonlight:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.
  * E2S2 - The Heart Forest:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.
  * E2S7 - Proximus:
    * Updated map to use the ^Ftd palm forest terrain on Wesnoth 1.11.x instead
      of the denser ^Ft tropical forest.
  * E2S8 - And then there was Chaos:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.
  * E2S9 - New Hive:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.
  * E2S10 - The Betrayal:
    * Solve protect_leader deprecation warning on Wesnoth 1.11.5 and later.

* Units:
  * Changed the faerie race's internal id from 'fairy' to 'faerie', and
    updated image paths accordingly. For compatibility, units on the map and
    recall lists with the old race id and image paths will be automatically
    fixed when loading a saved game, but the code in charge of this is not
    all-inclusive. When in doubt, players are advised to resume from the last
    start-of-scenario save available.
  * Added smoke effects to the Iron Golem's ranged attack animation.


Version 0.9.3:
--------------
* General:
  * Solved wmlxgettext error on themes/ats-cutscene.cfg due to bug fix in
    previous version.

* Graphics:
  * New or updated items: goal highlight overlay.

* Scenarios:
  * E3S2.1 - Return to Raelthyn:
    * Fix Adavyan’s backstory event being triggered by every player move on
      the map.
  * E3S10 - Blood:
    * Fixed viewport being permanently locked after the third stage begins on
      Wesnoth 1.11.x.


Version 0.9.2:
--------------
* General:
  * Dropped workaround code from 0.9.0 for a bug causing side data loss
    throughout Episode III on Wesnoth 1.11.1. Use Wesnoth 1.11.2 or later
    instead.
  * Various code optimizations taking advantage of features introduced during
    Wesnoth 1.9.x that were not used before AtS E3S7.1 before.

* Graphics:
  * New or updated unit graphics: Uria.

* Scenarios:
  * E1S3 - Civil War in the North:
    * Fixed elvish sides being visible on the game Status Table before the
      protagonists reach the fort.
  * E3S2.1 - Return to Raelthyn:
    * Added a statue prop with backstory information about Adavyan.

* Units:
  * Fixed "Terrain '**' has evaluated to 100 (cost) [...]" warnings on Wesnoth
    1.11.x caused by Aragwaith units.
  * Description changes:
    * New descriptions for Verlissh Matrix Core, Matrix Flow System, Psy
      Crawler, Psy Mindraider units.
    * New Imps race description.
    * New Spirits race description.
    * Fixed typo in Demons race description.
  * Made it so Verlissh Matrix Core and Matrix Flow System’s sprites are scaled
    down on the sidebar only when standing unit animations are disabled.

* User interface:
  * Made sure cutscene theme with menu bar works on Wesnoth 1.11.5 and later
    (affecting E1S6.2, E1S7x, E1S11x, E2S3.2, E2S5x).


Version 0.9.1:
--------------
* General:
  * Added workaround code for a problem with the [lock_view] implementation and
    its interaction with unit movement via [move_unit_fake]/[move_unit] on
    Wesnoth 1.11.x.
  * Made it so sequences using [animate_attack] do not display a floating label
    when dealing 1 HP damage since most of the time this is a consequence of
    dealing 100% HP on the target with kill=no, or other reasons along the same
    line.

* Graphics:
  * New or updated unit graphics: Elynia, Ivyel, Argan.

* Scenarios:
  * Fixed several instances (E1S7, etc.) of sighted events taking place
    prematurely on Wesnoth 1.11.x.
  * Fixed several instances of loyal units auto-recall code causing warnings on
    Wesnoth 1.11.x.
  * Minor prose fixes, tweaks, and enhancements throughout the entire campaign.
  * E1S7 - The Search for the Past:
    * Glyphs needed to end the scenario are now marked with a blinking tile
      outline (requires halos to be enabled in Display preferences).
    * Minor cutscene improvements.
    * Reworked message glyphs' code so their messages can be triggered as many
      times as the player wants (NOTE: the last glyph triggered will still
      unconditionally trigger the end of the scenario).
  * E1S9.1 - The Triad, part 1:
    * Minor gameplay improvements.
    * Removed duplicate character line during the initial sequence.
  * E1S9.2 - The Triad, part 2:
    * Reworked some code for increased robustness.
  * E1S9.3 - The Triad, part 3:
    * Reworked some code for increased robustness.
  * E1S10 - Tears:
    * Fixed gold carryover from E1S8 (Fear) being reduced to its 40% (for an
      effective carryover of 16%) when calculating the initial player gold
      supply for this scenario.
    * Reduced minimum starting gold to compensate for the bug fix above.
  * E1S11.1 - Return to Wesmere, part 1:
    * Fixed "retrieving member of non-existent WML container" warnings at the
      start of the scenario.
  * E1S11.2 - Return to Wesmere, part 2:
    * Fixed spurious "retrieving member of non-existent WML container" warning
      at the end of the scenario.
  * E2S1 - By the Moonlight:
    * Minor balancing changes.
  * E2S4 - Shifting Allegiances:
    * Minor map balancing tweaks.
    * Reduced turn limit from 34/33/32 to 28/27/26.
    * Other minor balancing changes.
  * E2S7 - Proximus:
    * Fixed minor fog refresh issues during the initial cutscene.
  * E2S8 - And then there was Chaos:
    * Minor balancing changes to increase difficulty.
  * E2S9 - New Hive:
    * Minor balancing changes.
  * E3S3 - Amidst the Ruins of Glamdrol:
    * Apply the default AMLA to Kyara and Horo a predefined amount of times on
      prestart according to the difficulty level.
    * Made it so neither the player nor Nar-hamoth can land a hit on each other.
  * E3S4 - Outpost of Hell:
    * Fix specific units being unintentionally visible during a white screen
      sequence.
    * Fixed "trying to remove non-existent menu item" warning at the end of
      the scenario on Wesnoth 1.11.x under certain conditions.
    * Make sure side 2 units also get their demolition ability and overlay
      removed at the end.
  * E3S5 - Pass of Sorrows:
    * Make the teleportation/exposition event in the middle of the scenario
      work as intended.
  * E3S7B - Dark Sea:
    * Make the northwestern Shaxthal and eastern undead sides less prone to
      stealing player villages.
  * E3S9 - Dark Depths:
    * Minor boss fight improvements.
    * Minor cutscene improvements.
  * E3S10 - Blood:
    * Made the foreshadowing moon combination have a x4 multiplier effect
      instead of x5 on all difficulty levels, not just Hard.
  * E3S13 - Epilogue:
    * Fixed some cutscene-only female units not having their gender specified
      in WML or translatable strings.
    * This scenario is now only accessible after recovering an object hidden in
      a previous scenario.

* Terrains:
  * Experimental fix for the long-standing gate clipping issue when adjacent to
    stone wall corners.

* Units:
  * Added sidebar icon for units affected by the 'stun' weapon special.
  * Added sidebar icon for units affected by the movement range bind spell.
  * Applied changes from Astrid's "The Aragwaithi" add-on, versions 1.0.6
    through 1.0.9, and "Era of Chaos" version 1.1.0:
    * Archer HP increased from 26 to 28.
    * Granted the new 'precision' weapon special to the Greatbow's ranged
      attack.
    * Increased Guard's blade resistance from 10% to 20%.
    * Increased Guard's XP from 64 to 74.
    * Decreased Guard's cost from 28 to 27.
    * Decreased Pikeman's cost from 38 to 28.
    * Increased Shield Guard's cost from 37 to 45.
    * Increased Shield Guard's blade and pierce resistances from 10% to 20%.
    * Granted the 'marksman' weapon special to the Swordsmaster.
    * Renamed the Aragwaith Witch's image files (may break saved games from
      E3S2).
    * Various animation fixes and updates.
  * Balancing:
    * Increased Elynia's (E3) mystic fire attack strength from 5-4 to 5-5.
    * Increased Elynia's (post-Divergence) ensnare attack strength from 9-3 to
      9-4.
    * Increased Forest Spirit's movement points from 5 to 6.
    * Decreased Fallen Faerie's HP from 49 to 43.
    * Decreased Fallen Faerie's wail attack strength from 12-3 to 11-3.
  * Gave Anya and Elynia special AMLAs for E2 and E3.
  * Fixed wrong description for Galas' bolas attack AMLA (stated magical as the
    weapon special, it is actually slows).


Version 0.9.0:
--------------
* General:
  * Milestone: all scenarios completed.

* Scenarios:
  * Deployed code to work around a side-switching issue affecting Wesnoth
    1.11.1 during post-Divergence (E3S6) scenarios. The corresponding
    mainline bug is #20373 and it is fixed on 1.11.2.
  * Fixed various "wesnoth.get_side is deprecated, use wesnoth.sides instead"
    warnings on 1.11.x.
  * Minor story text grammar, style, and punctuation amendments.
  * E1S6 - Quenoth Isle (Elves of a Different Land):
    * Minor prose tweaks.
  * E1S7 - The Search for the Past:
    * Minor prose tweaks.
  * E1S12 - The Queen:
    * Minor prose tweak.
  * E1S13 - Death and Rebirth:
    * Fixed minor prose issue ("take risky choices" -> "make risky choices").
  * E2S2 - The Heart Forest:
    * Minor prose tweak.
  * E2S11 - A Final Confrontation:
    * Minor cutscene improvements near the end.
  * E2S12 - Fate:
    * Minor cutscene improvements.
  * E3S8C - Breakdown:
    * Don't allow summoning Fire Guardians until the player enters the
      underground river passage.
    * Fix objectives display inconsistencies throughout the scenario.
    * Minor cutscene improvements.
  * E3S8D - Destiny, part 2:
    * Fixed Anya's movements not being undoable.
  * E3S9: Dark Depths:
    * Fixed minor cutscene glitches.
  * E3S10 - Blood:
    * Add a context menu item displaying a list of available attack
      combinations and their effects.
  * E3S13 - Epilogue:
    * New scenario.

* Units:
  * Balancing:
    * Decreased Demon Slashing Gale's melee attack from 11-3 to 10-3.
    * Decreased Demon Slashing Gale's ranged attack from 10-5 to 9-4.
  * Fixed Chaos Arbalestier ranged attack animation failing to trigger.
  * Fixed Shaxthal Turret not getting the biomechanical trait.
  * Fix multiple "Descriptions should no longer include the name as the first
    line" warnings on 1.11.1 and later.
  * Fix unit types with missing faction prefixes in their names:
    * Arbalestier -> Chaos Arbalestier
    * Cataphract -> Chaos Cataphract
    * Crossbowman -> Chaos Crossbowman
    * Heavy Longbowman -> Chaos Heavy Longbowman
  * Hide private variations for regular unit types from the help system on
    1.11.x.
  * Killed Kri'tan.


Version 0.8.90.1:
-----------------
* General:
  * All episodes have 13 scenarios each. Reasoning:
    * E1: the line-up goes from E1S1 through E1S13
    * E2: the line-up goes from E2S0 through E2S12
    * E3: the line-up goes from E3S0 through E3S12 and E3S13 will be a bonus
      feature in future versions

* Scenarios:
  * E3S4.1 - Outpost of Hell:
    * Fix "[object]duration=level is deprecated" warning on 1.11.x.
  * E3S6 - Divergence:
    * Fix "[object]duration=level is deprecated" warning on 1.11.x.
  * E3S10 - Blood:
    * Avoid hitting BUG_ON path when the Blood Core handler runs after stage 2.
    * Replaced comments causing wmlxgettext errors.

* Units:
  * Fix "[object]duration=level is deprecated" warnings on 1.11.x affecting
    scenarios where units with the stun weapon special (e.g. Valdemon Basher)
    are present.


Version 0.8.90 a.k.a. "0.9.0 minus one":
----------------------------------------
* General:
  * Dropped remaining compatibility code for Wesnoth 1.9.14 and earlier.

* Scenarios:
  * E1S11.2 - Return to Wesmere, part 2:
    * Removed compatibility code for Wesnoth 1.9.5 through 1.9.8.
  * E3S6 - Divergence:
    * Enabled new scenario.
  * E3S7A - Dark Fire:
    * New scenario.
  * E3S7B - Dark Sea:
    * New scenario.
  * E3S8A - Interim:
    * New scenario.
  * E3S8B - Destiny, part 1:
    * New scenario.
  * E3S8C - Breakdown:
    * New scenario.
  * E3S8D - Destiny, part 2:
    * New scenario.
  * E3S9 - Dark Depths:
    * New scenario.
  * E3S10 - Blood:
    * New scenario.
  * E3S11 - After the Storm:
    * New scenario.
  * E3S12 - Destiny, part 3:
    * New scenario.

* Units:
  * Balancing:
    * Increased Elynia's resistance to impact damage from -10% to 0%.
    * Decreased Demon Shapeshifter's ranged attack from 8-2 to 7-2.


Version 0.8.5:
--------------
* General:
  * Added a note at the start of every episode regarding Display preferences
    that may affect cutscenes.
  * Added title cards to every scenario in episode I and II that is supposed to
    have one, and added the production code for each individual scenario to all
    title cards.
  * Changed the order in which title cards display during E3.
  * Fixed hive spawns not getting random traits as intended.
  * New campaign difficulty menu icons for episodes II and III.

* Graphics:
  * New or updated unit graphics: Chaos Arbalestier.

* Scenarios:
  * E1S1 - The Skirmish:
    * Revised/rewritten dialog lines.
    * Revised/rewritten story text.
  * E1S2 - High Pass:
    * Revised/rewritten dialog lines.
    * Revised/rewritten story text.
  * E1S3 - Civil War in the North:
    * Revised/rewritten dialog lines.
    * Revised/rewritten story text.
  * E1S4 - Terror at Dusk:
    * Revised/rewritten dialog lines.
    * Revised/rewritten story text.
  * E1S5 - Bay of Tirigaz:
    * Revised/rewritten dialog lines.
  * E1S6 - Quenoth Isle (Elves of a Different Land):
    * Revised/rewritten dialog lines.
    * Revised/rewritten story text.
  * E1S11.2 - Return to Wesmere, part 2:
    * Add workaround for mainline bug #20350 on 1.10.5 and earlier, which
      allowed the player to end their first turn prematurely by save-reloading.
  * E2S12 - Fate:
    * Shrank Elynia's HP bar as much as possible and eliminated her XP bar.
  * E3S0 - Opening:
    * Fixed minor story text persistence glitch on large resolutions (e.g.
      1920x1080).
    * Removed title card.
  * (Unreleased scenarios):
    * Add workaround for mainline bug #20351 on 1.10.5 and earlier.

* Units:
  * Renamed Chaos Advanced Crossbowman to Chaos Arbalestier.


Version 0.8.4:
--------------
* General:
  * Dropped remaining compatibility code for Wesnoth 1.9.9 and earlier.

* Graphics:
  * New or updated items: crystal glyphs.
  * New or updated unit graphics: Sprite, Fire Faerie, Forest Spirit, Dryad,
    Elvish Acolyte, Elvish Ascetic, Elvish Mystic, Elvish Avatar,
    Civilian/Messenger, Dusk Faerie, Night Nymph, Nightshade Fire.

* Scenarios:
  * E2S4 - Shifting Allegiances:
    * Gave Tara a unique baseframe.

* Units:
  * Balancing:
    * Farmland no longer applies for the effects of the Sylvan Spark and Sylvan
      Essence abilities.
    * Reduced Shaxthal elusivefoot defense on Deep Water from 20% to 10%
      (Shaxthal Rayblade, Shaxthal Stormblade, Elyssa).
  * Fixed Chaos Longbowman and Heavy Longbowman melee attack animations.
  * Give Forest Spirits the 'spirit' trait instead of 'undead'. Note that as a
    side-effect, existing instances of this unit will get both traits when
    loading from saved games.


Version 0.8.3:
--------------
* General:
  * Preliminary (untested) Wesnoth 1.11.0 support. There might be serious
    campaign-specific bugs, so players on this version should report their
    experience regardless of failure or success. This same version of the
    campaign will continue to support Wesnoth 1.10 until Wesnoth 1.12 RC 1 is
    released at an indeterminate point in the future.

* Scenarios:
  * Replaced a bunch of instances of "in the battlefield" with "on the
    battlefield".
  * E1S9.1 - The Triad, part 1:
    * Minor cosmetic changes that totally have no plot significance whatsoever.
  * E3S4.1 - Outpost of Hell:
    * Make sure to remove the demolition ability overlay from units when the
      siege charges are disabled by the boss event.
    * Prevent log spam about retrieving non-existent WML variables immediately
      before and after the boss event.
  * E3S6 - Divergence:
    * New scenario, disabled in production until the rest is completed.

* Units:
  * Allow the Demon Shapeshifter to get the default AMLA.


Version 0.8.2:
--------------
* Scenarios:
  * E3S4.1 - Outpost of Hell:
    * Limit Demon Shapeshifter spawns according to the difficulty level.
    * Recall all loyal side 2 units for free at the start.
    * Reveal Demon Shapeshifters with their remaining moves and attacks set to
      zero during their controlling side's turn.
  * E3S5 - Pass of Sorrows:
    * Improved handling of non-Elynia units stepping on the monolith location
      both before and after its "activation".

* Units:
  * Balancing:
    * Decreased Demon Shapeshifter's HP from 47 to 44.
    * Decreased Demon Shapeshifter's melee attack from 8-3 to 7-3.
    * Decreased Demon Shapeshifter's ranged attack from 9-2 to 8-2.


Version 0.8.1:
--------------
* Graphics:
  * New or updated unit graphics: most Aragwaith units (wayfarer).

* Scenarios:
  * E2S3.1 - Unrest in Raelthyn:
    * Updated to use Aragwaith units.
  * E2S8 - And then there was Chaos:
    * Fixed elves who are initially Loyal getting a duplicate
      trait when switching allegiances.
  * E3S2.1 - Return to Raelthyn:
    * Minor map balancing changes.
  * E3S4 - Outpost of Hell (Gateway):
    * New scenario.
  * E3S5 - Pass of Sorrows (Gathering Storm):
    * New scenario.

* Sound effects:
  * Added hit and death sounds for Doors.
  * Added additional explosion/thunder sounds.
  * Added magic glyph sounds.

* Units:
  * Balancing:
    * Removed marksman special from the Demolisher Drone's ranged attack.
    * Increased Sprite's impact resistance from -20% to 0%.
    * Increased Fire Faerie's impact resistance from -20% to 0%.
    * Increased Dryad's impact resistance from -10% to 0%.
    * Increased Aragwaith Seer's HP from 39 to 44.
    * Increased Aragwaith Seer's melee attack from 7-2 to 8-2.
    * Increased Aragwaith Seer's ranged attack from 8-3 to 10-3.
    * Decreased Shaxthal Razorbird's melee attack from 10-1 to 8-1.
    * Decreased Shaxthal Thunderbird's melee attack from 13-1 to 10-1.
  * Gave Doors a unit icon for the sidebar and the attack dialog.
  * Updated Aragwaith units to match the faction from Astrid's
    "The Aragwaithi" add-on. This has resulted in the following changes:
    * Protection only affects allied L1 and L0 units instead of any allied
      lower level unit
    * Ancient Banner abilities: +leadership, -protection, -steadfast
    * Ancient banner resistances: impact 10% -> 20%
    * Ancient banner stats: HP 55 -> 58, MP 4 -> 5
    * Ancient banner attacks: sword renamed to scythe
    * Archer attacks: melee 6-3 -> 4-3
    * Captain abilities: +leadership, -protection, -steadfast
    * Captain resistances: blade 20% -> 10%, fire 10% -> 0%, cold 10% -> 0%,
      pierce 20% -> 10%
    * Captain stats: HP 43 -> 55, MP 4 -> 5
    * Captain attacks: spear renamed to glaive, 17-2 -> 18-2; sword renamed to
      glaive, 9-4 -> 10-4
    * Eagle Master stats: HP 48 -> 45, MP 7 -> 9
    * Eagle Master attacks: blade 9-3 -> 10-3, impact 15-2 -> 16-2
    * Eagle Rider defense: mountain 60% -> 50%
    * Eagle Rider stats: HP 36 -> 34, MP 7 -> 9, cost 21 -> 23
    * Eagle Rider attacks: impact 10-2 -> 12-2
    * Flagbearer abilities: +leadership, -protection, -steadfast
    * Flagbearer resistances: blade 20% -> 10%, fire 10% -> 0%, cold 10% -> 0%,
      pierce 20% -> 0%, impact 10% -> 0%
    * Flagbearer stats: HP 34 -> 45, MP 4 -> 5
    * Flagbearer attacks: spear renamed to glaive, sword renamed to glaive
    * Greatbow stats: HP 43 -> 46, MP 5 -> 6
    * Greatbow attacks: melee 13-3 -> 10-3
    * Guard abilities: +steadfast
    * Guard resistances: pierce 20% -> 10%, impact 20% -> 10%, blade 30% -> 10%
    * Guard stats: HP 40 -> 54, XP 78 -> 64, cost 27 -> 28
    * Guard attacks: melee 12-3 -> 11-3
    * Guardian resistances: fire 10% -> 0%, cold 10% -> 0%
    * Guardian stats: HP 51 -> 62
    * Lancer now has a female variation
    * Lancer stats: HP 40 -> 48, cost 38 -> 34
    * Longswordsman stats: HP 38 -> 46, MP 5 -> 6, XP 78 -> 88, cost 24 -> 27
    * Pikeman resistances: blade 20% -> 10%, impact 10% -> 0%, fire 10% -> 0%,
      cold 10% -> 0%
    * Pikeman stats: HP 44 -> 50, XP 94 -> 70
    * Pikeman attacks: melee 17-2 -> 16-2
    * Scout now has a female variation
    * Scout stats: HP 31 -> 36, XP 36 -> 40
    * Scout attacks: melee 10-2 -> 11-2
    * Shield Guard abilities: +protection, +steadfast
    * Shield Guard resistances: pierce 30% -> 10%, impact 30% -> 10%, blade
      40% -> 10%
    * Shield Guard stats: HP 54 -> 66
    * Shield Guard attacks: melee 16-3 -> 15-3
    * Silver Shield now has a female variation
    * Silver Shield stats: HP 54 -> 62, MP 8 -> 9, cost 38 -> 48
    * Silver Shield attacks: melee 13-4 -> 12-4
    * Slayer stats: HP 45 -> 53, MP 5 -> 6, cost 46 -> 62
    * Slayer attacks: melee 12-4 -> 11-4
    * Sorcerer renamed to Sorceress, no longer has a male variation
    * Spearman resistances: blade 20% -> 0%, pierce 20% -> 10%, impact 10% ->
      0%, fire 10% -> 0%, cold 10% -> 0%
    * Spearman stats: HP 30 -> 34, XP 38 -> 43
    * Spearman attacks: 11-2 -> 12-2
    * Strongbow stats: HP 35 -> 38, MP 5 -> 6, XP 80 -> 85, cost 31 -> 38
    * Strongbow attacks: melee 9-3 -> 7-3, ranged 8-4 -> 9-4
    * Swordsmaster id changed, breaking old saved games with the unit
    * Swordsmaster stats: MP 5 -> 6
    * Swordsman resistances: blade 10% -> 0%
    * Swordsman stats: HP 28 -> 32, XP 32 -> 39, cost 13 -> 14
    * Warlock renamed to Witch, no longer has a male variation
    * Witch stats: XP 44 -> 54, cost 18 -> 22
    * Witch attacks: staff renamed to kick, 6-2 -> 7-1
    * Wizard no longer has a male variation
    * Wizard attacks: melee 10-2 -> 7-2, ranged 11-3 -> 10-3


Version 0.8.0:
--------------
* Scenarios:
  * Mal Hekuba now wears purple TC as he did in IftU.
  * E2S12 - Fate:
    * Avoid crash on Mac OS X during the prestart event.
  * E3S0 - Opening (Within):
    * New scenario.
  * E3S1 - Beyond her Smile (A Light in the Darkness):
    * New scenario.
  * E3S2 - Return to Raelthyn (Reckoning):
    * New scenario.
  * E3S3 - Amidst the Ruins of Glamdrol (A Path to Follow):
    * New scenario.

* Units:
  * Balancing:
    * Increased Chaos Hound's recruit cost from 18 to 20.
    * Increased Shaxthal Razorbird's recruit cost from 18 to 19.
    * Decreased Shaxthal Runner Drone's ranged attack strength from 8-3 to 7-3.
  * Fixed invisible Chaos Longbowman and Heavy Longbowman units due to missing
    graphics.
  * Fixed Elvish Trapper and Elvish Prowler disappearing during animations.
  * Fixed NPC bird code deleting the previous on-map unit when moving a
    bird to an occupied hex (i.e. worms in E2S9).
  * Removed Kri'tan.


Version 0.7.4:
--------------
* Graphics:
  * New or updated unit graphics: Shaxthal Warlord Nar-Hamoth

* Music:
  * All current music tracks have been moved to a separate add-on,
    imaginatively titled "AtS Music". This add-on is now an optional dependency
    for those who can't afford downloading it or don't play with music enabled.
    When absent, the AtS campaign menu entries for each episode will include a
    notice stating so.

* Scenarios:
  * E2S5 - The Eastern Front:
    * Added a time-over dialog sequence.
    * Added an additional dialog sequence focusing on a specific
      player character.
  * E2S6 - The Voyage Home:
    * Added a time-over dialog sequence.
  * E2S7 - Proximus:
    * Added a time-over dialog sequence.
  * E2S8 - And then there was Chaos:
    * Fixed elves not getting the Loyal trait.
  * E2S9 - New Hive:
    * Fixed Shaxthal Worms changing colors when moving.
    * Reduced starting gold.
  * E2S10 - The Betrayal:
    * Fixed multiple "invalid WML array index" warnings at the start.
    * Reduced starting gold.
  * E2S11 - A Final Confrontation:
    * Made the glyph guardians a little more competent.
  * Healing glyphs no longer render affected units unable to attack on the
    same turn.

* Units:
  * Balancing:
    * Increased arcane damage resistance for most Shaxthal units from -50% to
      -20%.
    * Decreased Demon Zephyr's movement cost on deep water terrains from 2 to 1.
    * Decreased Demon Zephyr's movement cost on unwalkable terrains from 3 to 1.
  * Reimplemented NPC bird behavior code in Lua.
  * Renamed "Shaxthal Warlord" unit type to "Shaxthal Warlord Narhamoth";
    this breaks old saved games of E1S9.1 (The Triad, part 1) during turns.


Version 0.7.3:
--------------
* Graphics:
  * New or updated unit graphics: Dusk Faerie, Night Nymph, Nightshade Fire.

* Scenarios:
  * E1S7 - The Search for the Past:
    * Update objectives accordingly to remind the player to move Elynia to the
      sealed glyph when she doesn't find it first.
  * E1S9.1 - The Triad, part 1:
    * Minor graphic improvements.
  * E1S12 - The Queen:
    * Fixed multiple "cannot show message" warnings.
  * E2S2 - The Heart Forest:
    * Tweaked the initial spawn locations of Allyna and her pursuers in an
      attempt to make the ambush event a little less frustrating.
  * E2S4 - Shifting Allegiances:
    * Various map and code changes to increase difficulty.
  * E2S12 - Fate:
    * Minor graphic improvements.

* Units:
  * New or updated descriptions: Chaos Lorekeeper.
  * Improved unit animations: Dusk Faerie, Night Nymph, Nightshade Fire, Faerie
    Avatar, Shaxthal Queen.
  * Optimized or fixed unit animations: Goliath, Sylvan Warden, Sprite, Fire
    Faerie, Dryad, Forest Spirit, Shaxthal Warlord.
  * Balancing:
    * Increased Forest Spirit's resistance to fire damage from 0% to 20%.
      * Note that this is actually a bugfix; the original fire resistance
        specified was 20%, but there was spurious left-over code switching
        it to 0%.
    * Increased Forest Spirit's resistance to arcane damage from -20% to -10%.
    * Decreased Forest Spirit's resistance to cold damage from 70% to 0%.


Version 0.7.2:
--------------
* Scenarios:
  * E1S9.3 - The Triad, part 3:
    * Fix problem causing Mal Keshar to be recalled in the next scenario with
      no movements for the first turn.
  * E1S11.1 - Return to Wesmere, part 1:
    * Minor difficulty tweaks by vultraz.
  * E1S11.2 - Return to Wesmere, part 2:
    * Reduced chance of the player being unwittingly attacked by drones from
      offscreen at the start.
    * Minor difficulty tweaks.
  * E1S12 - The Queen:
    * Do not let petrified units level-up.
    * Fixed typo ("where" -> "were").
    * Minor difficulty tweaks.
    * Minor cutscene sequence changes.
  * E2S10 - The Betrayal:
    * Minor cutscene sequence changes.
  * E2S11 - A Final Confrontation:
    * Minor cutscene sequence changes.

* Units:
  * Force a shroud/fog refresh whenever a door is destroyed.


Version 0.7.1:
--------------
* Graphics:
  * New or updated unit graphics: Elvish Acolyte, Elvish Ascetic, Elvish
    Mystic, Elvish Avatar, Elvish Wayfarer, Shaxthal Stormblade.

* Scenarios:
  * E1S1 - The Skirmish:
    * Increased overall difficulty, and reduced turn limit.
  * E1S3 - Civil War:
    * Fixed the unintended visible floating crown in the bottom right corner
      of the game map.
    * Made this scenario easier.
  * E1S5 - Bay of Tirigaz:
    * Made the defeat condition involving the ally leader actually work.
    * Removed unintended forced recall.
  * E1S7 - The Search for the Past:
    * Added villages, minor difficulty changes.
  * E1S8 - Fear:
    * Increased overall difficulty, and increased turn limit.
  * E1S9.1 - The Triad, part 1:
    * Minor dialogue changes.
  * E1S9.2 - The Triad, part 2:
    * Minor Shaxthal encounter changes.
  * E2S8 - And then there was Chaos:
    * Applied minor prose suggestions from Muspilli.
  * E2S11 - A Final Confrontation:
    * Remove "turns run out" condition from the Objectives display whenever
      appropriate

* Units:
  * Balancing:
    * Increased Shaxthal Stormblade's resistances:
      * Fire: -10% -> 10%
      * Arcane: -50% -> -10%
    * Increased Shaxthal Stormblade's movement from 5 to 6.
    * Increased Shaxthal Stormblade's HP from 49 to 67.
    * Added a ranged attack for the Shaxthal Stormblade.
    * Increased Shaxthal Infiltrator's resistances:
      * Blade: 0% -> 20%
      * Pierce: 0% -> 30%
      * Impact: -10% -> 0%
      * Cold: 0% -> 10%
  * Fixed a missing image error with one of Galas' AMLA options.
  * Optimized or fixed unit animations: Fire Sprite unit tree, Control Spire,
    Flow System, Matrix Core, Shaxthal Runner Drone line, Shaxthal Drone tree.
  * Removed compatibility with pre-Wesnoth 1.9.10 AMLA XP requirements.


Version 0.7.0:
--------------
* Graphics:
  * New or updated unit graphics: Dusk Faerie, Shaxthal Worm, Shaxthal
    Rayblade, Shaxthal Assault Drone, Shaxthal Protector Drone, Shaxthal War
    Drone, Shaxthal Runner Drone.
  * New or updated terrain graphics: Dark Hive Floor (transitions).

* Scenarios:
  * E1S5 - Bay of Tirigaz:
    * Rewrote shipwreck generator code so the message strings can actually
      be translated.
  * E1S8 - Fear:
    * Updated to use a Wesnoth 1.9.10 terrain.
  * E2S1 - By the Moonlight:
    * Updated to use a Wesnoth 1.9.10 terrain.
  * E2S2 - The Heart Forest:
    * Updated to use a Wesnoth 1.9.10 terrain.
  * E2S4 - Shifting Allegiances:
    * Fixed a local variable leak.
  * E2S6 - The Voyage Home:
    * Updated to use a Wesnoth 1.9.10 terrain.
  * E2S7 - Proximus:
    * Added a hint regarding the enemy leader's chance-to-hit override to
      objectives.
    * Fixed animation glitches.
  * E2S8 - And then there was Chaos:
    * New scenario.
  * E2S9 - New Hive:
    * New scenario.
  * E2S10 - The Betrayal:
    * New scenario.
  * E2S11 - A Final Confrontation:
    * New scenario.
  * E2S12 - Fate:
    * New cutscene scenario.
  * Completed episode II.

* Units:
  * New unit: Shaxthal Worm (replaces the Shaxthal Wyrm).
  * Balancing:
    * Reduced Nightshade Fire's ranged arcane attack strength from 12-3 to 10-3.
    * Reduced Nightshade Fire's ranged cold attack strength from 13-2 to 11-2.
    * Reduced Night Nymph's ranged arcane attack strength from 9-3 to 8-3.
    * Increased Errant Soul's ranged attack strength from 2-1 to 2-2.
    * Reduced Chaos Headhunter's ranged attack strength from 6-3 to 5-3.
    * Reduced Chaos Marauder's axe attack strength from 10-2 to 8-2.
    * Reduced Chaos Marauder's ranged attack strength from 7-3 to 6-3.
    * Reduced Chaos Soulhunter's axe attack strength from 13-2 to 12-2.
    * Reduced Chaos Soulhunter's ranged attack strength from 10-3 to 9-3.
  * Revised Shaxthal unit descriptions.
  * Shaxthal Runner Drones can no longer advance to Assault Drones.
  * Added a custom teleport animation for Nightshade Fire.
  * Added unit type descriptions for Night Nymph and Nightshade Fire.
  * Removed conflicting markup from the Sylvan Warden unit type description.


Version 0.6.1:
--------------
* Increased minimum Wesnoth version requirement from 1.9.7 to 1.9.10.

* Graphics:
  * New or updated unit graphics: Sylvan Warden (chained).

* Scenarios:
  * Various prose grammar fixes.
  * E1S3 - Civil War in the North:
    * Removed deprecated flower terrain.
  * E1S5 - Bay of Tirigaz:
    * Removed deprecated flower terrain.
  * E1S6.2 - Elves of a Different Land:
    * Fixed a dialog line wrapped in double parentheses.
  * E1S9.1 - The Triad (part 1):
    * Don't set Elynia's initial status to slowed.
    * Fixed animation glitches.
  * E1S9.3 - The Triad (part 3):
    * Fixed animation glitches.
  * E2S2 - The Heart Forest:
    * Increased turn limit.
    * Reduced initial gold amounts for enemy sides.
    * Set initial gold amount for the player.
  * E2S3.2 - Revelations:
    * Corrected unit facings.
  * E2S4 - Shifting Allegiances:
    * New scenario.
  * E2S5 - The Eastern Front:
    * New scenario.
  * E2S5 C - The Eastern Front cutscene:
    * New scenario.
  * E2S6 - The Voyage Home:
    * New scenario.
  * E2S7 - Proximus:
    * New scenario.

* Units:
  * Increased Dryad's HP from 43 to 46.
  * Increased Forest Spirit's HP from 37 to 40.
  * Simplified Sylvan Warden's animations WML, making her less of a resource
    hog.
  * Removed Kri'tan.


Version 0.6.0:
--------------
* Increased minimum Wesnoth version requirement from 1.9.5 to 1.9.7.

* Scenarios:
  * Reworked character recall logic.
  * Episode 2 (Fate):
    * Scenarios 1 and 2 completed.
    * Scenario 3 completed, consisting of two cutscenes.

* Units:
  * Reduced Sprite's required XP to advance from 70 to 40.
  * Reduced Fire Faerie's required XP to advance from 100 to 70.


Version 0.5.4:
--------------
* The campaign passes wmllint validation now.

* Scenarios:
  * Various spelling fixes.
  * E1S1 - The Skirmish:
    * The death of the ally leader is supposed to be a defeat condition.
  * E2 - codename "Fate":
    * Very early work on E2S0 (Transience) and E2S1 (By the Moonlight). Since
      the storyline isn't fixed yet and there is only one playable scenario at
      this time, this episode is currently unavailable in regular gameplay.

* Units:
  * Various spelling fixes.
  * Removed Kri'tan.


Version 0.5.3:
--------------
* Graphics:
  * New or updated unit graphics: Shaxthal Drone, Shaxthal Runner Drone,
    Shaxthal Sentry Drone, Shaxthal Enforcer Drone, Shaxthal Hive Queen.

* Units:
  * Updated AMLA XP requirements to match mainline on 1.9.10 and later.


Version 0.5.2a:
---------------
* Fixed a "unknown unit" error on scenario 06.


Version 0.5.2:
--------------
* Scenarios:
  * Merged various prose suggestions and fixes from Pentarctagon, AI and vultraz
    from the forum topic.
  * 06 - Quenoth Isle:
    * Minor improvements.
  * 12 - The Queen:
    * Fixed a case where Mal Keshar could speak when he isn't supposed to.
    * Minor improvements.

* User interface:
  * Removed map borders overlay from fullscreen cutscene UI.


Version 0.5.1:
--------------
* Scenarios:
  * Fixed several inconsistencies regarding cutscene linger mode.

* Units:
  * Turned Galas' bolas attack into an AMLA.
  * Turned Galas' ambush ability into an AMLA.
  * Gave Galas more AMLAs: Strength I, Strength II.

* User interface:
  * Cutscene-only scenarios now use custom UI themes lacking sidebars and other
    useless cruft.


Version 0.5.0a:
---------------
* Fixed a minor issue with the credits screen background.


Version 0.5.0:
--------------
* Scenarios:
  * 09 - The Triad (part 3):
    * Fixed problems with the final cutscene on Wesnoth 1.9.8 and earlier.
  * 11 - Return to Wesmere (part 2):
    * New scenario.
  * Completed episode I.

* Units:
  * Removed Skirmisher ability from Elynia.
  * Spawners have a small chance of deactivating themselves after spawning a
    unit.


Version 0.4.4:
--------------
* Scenarios:
  * 10 - Tears:
    * Made significantly easier.
    * Fixed missing gold carryover from scenario 08.
  * 11 - Return to Wesmere (part 1):
    * New scenario.

* Units:
  * New NPC bird behavior code.


Version 0.4.3:
--------------
* Scenarios:
  * 07 - The Search for the Past:
    * Fix the poisoned recalls bug for real now; this also fixes an ugly case
      of saved game corruption resulting from that.
  * 09 - The Triad (part 1):
    * Don't allow cutscene helpers to be put into the recall list.


Version 0.4.2:
--------------
* Scenarios:
  * Removed player income in scenario 6 and 7 cutscenes.
  * 06 - Quenoth Isle/Elves of a Different Land:
    * Fixed gold carryover for scenario 07.
  * 07 - The Search for the Past:
    * Remove poison/slowed/ambush status from units at the end to avoid recall
      issues in later scenarios.
  * 07 - Resolutions:
    * Fixed gold carryover for scenario 08.
  * 09 - The Triad (part 1):
    * Fixed undead and faerie units in the recall list being killed in turn 2.


Version 0.4.1:
--------------
* Scenarios:
  * Added custom flag styles for various AI sides.
  * Minor wording changes, some of them contributed by tr0ll.
  * 10 - Tears:
    * New scenario.

* Units:
  * Renamed Chaos Lore to Chaos Lorekeeper.


Version 0.4.0:
--------------
* Scenarios:
  * 01 - The Skirmish:
    * Fix minor dialogue typo.
  * 03 - Civil War:
    * Fixed a little oversight causing gold to be actually carried over to the
      next scenario.
  * 05 - Bay of Tirigaz:
    * Fix minor dialogue typo.
  * 09 - The Triad:
    * New scenario.

* Units:
  * Removed help markup from the Sylvan Essence ability special notes to avoid
    issues in Pango contexts (e.g. sidebar tooltips).


Version 0.3.2:
--------------
* Graphics:
  * New or updated unit graphics: Shaxthal War Drone, Shaxthal Enforcer Drone,
    Sylvan Warden, Chaos Warlord

* Scenarios:
  * 08 - Fear:
    * New scenario.


Version 0.3.1:
--------------
* Scenarios:
  * 01 - The Skirmish:
    * Silenced some spurious variable engine warnings.
  * 05 - Bay of Tirigaz:
    * Fixed a loophole with the treasure spawns.
    * Fixed warnings about image file extensions with animated fountains.


Version 0.3.0:
--------------
* Way too many changes to list.


; kate: indent-mode normal; encoding utf-8; space-indent on; word-wrap on;
; kate: indent-width 2;
