local helper = wesnoth.require "lua/helper.lua"

function safe_random(arg)
	wesnoth.fire("set_variable", {
		name = "random",
		rand = arg,
	})

	local r = wesnoth.get_variable("random")
	wesnoth.set_variable("random")

	return r
end

---
-- Installs mechanical "Door" units on *^Z\ and *^Z/ hexes
-- using the given owner side.
--
-- [setup_doors]
--     side=3
-- [/setup_doors]
---
function wesnoth.wml_actions.setup_doors(cfg)
	local locs = wesnoth.get_locations {
		terrain = "*^Z\\",
		{ "or", { terrain = "*^Z/" } },
		{ "not", { { "filter", {} } } },
	}

	for k, loc in ipairs(locs) do
		wesnoth.put_unit(loc[1], loc[2], {
			type = "Door",
			side = cfg.side,
			id = string.format("__door_X%dY%d", loc[1], loc[2]),
		})
	end
end

---
-- Stores a list of unit ids matching a certain filter.
--
-- [store_unit_ids]
--     [filter]
--         ...
--     [/filter]
--     variable=ids_store
-- [/store_unit_ids]
---
function wesnoth.wml_actions.store_unit_ids(cfg)
	local filter = helper.get_child(cfg, "filter") or
		helper.wml_error "[store_unit_ids] missing required [filter] tag"
	local varid = cfg.variable or "units"
	local idx = 0
	if cfg.mode == "append" then
		idx = wesnoth.get_variable(var .. ".length")
	else
		wesnoth.set_variable(var)
	end

	for i, u in ipairs(wesnoth.get_units(filter)) do
		wesnoth.set_variable(string.format("%s[%d].id", varid, idx), u.id)
		idx = idx + 1
	end
end

---
-- Places an item in the map. Just like [item], but without the implicit [redraw].
--
-- [item_fast]
--     ... SLF ...
--     image=foo/bar.png
--     halo=baz/bat.png
-- [/item_fast]
---
function wesnoth.wml_actions.item_fast(cfg)
	local locs = wesnoth.get_locations(cfg)
	cfg = helper.parsed(cfg)

	if not cfg.image and not cfg.halo then
		--Nothing to do
		return
	end

	for i, loc in ipairs(locs) do
		-- FIXME: these items aren't going to be removed, so I'm
		-- not bothering with state tracking right now.
		wesnoth.add_tile_overlay(loc[1], loc[2], cfg)
	end
end

---
-- Removes the terrain overlay from every hex matching a given SLF.
--
-- [remove_terrain_overlays]
--     ... SLF ...
-- [/remove_terrain_overlays]
---
function wesnoth.wml_actions.remove_terrain_overlays(cfg)
	local locs = wesnoth.get_locations(cfg)

	for i, loc in ipairs(locs) do
		local locstr = wesnoth.get_terrain(loc[1], loc[2])
		wesnoth.set_terrain(loc[1], loc[2], string.gsub(locstr, "%^.*$", ""))
	end
end
