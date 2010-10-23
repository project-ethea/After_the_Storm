local helper = wesnoth.require "lua/helper.lua"

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
