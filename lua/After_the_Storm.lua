---
-- Lua WML actions that are intended specifically for use in the After the Storm
-- campaign.
---

local helper = wesnoth.require "lua/helper.lua"

----------
-- E1S9 --
----------

function spawn_loyal_player_unit(type_id, loc_x, loc_y)
	-- Inelegant, I know, but put_unit() invokes a code path
	-- where animate= doesn't have a meaning.
	wesnoth.fire("unit", {
		x = loc_x,
		y = loc_y,
		side = 1,
		type = type_id,
		upkeep = "loyal",
		animate = true,
	})
end

function wesnoth.wml_actions.s9_area_spawns(cfg)
	local num_skels = cfg.skeletons or 1
	local num_ghosts = cfg.ghosts or 1
	local locs = wesnoth.get_locations(cfg)

	for i = 1, num_skels do
		if #locs == 0 then
			return
		end
		local r = safe_random(string.format("1..%d", #locs))
		local x, y = locs[r][1], locs[r][2]
		spawn_loyal_player_unit("Skeleton", x, y)
		table.remove(locs, r)
	end

	for i = 1, num_ghosts do
		if #locs == 0 then
			return
		end
		local r = safe_random(string.format("1..%d", #locs))
		local x, y = locs[r][1], locs[r][2]
		spawn_loyal_player_unit("Ghost", x, y)
		table.remove(locs, r)
	end
end

-----------
-- E2S10 --
-----------

function wesnoth.wml_actions.deactivate_and_serialize_sides(cfg)
	local variable = cfg.variable or "sides"
	local array_index = 0

	wesnoth.set_variable(variable, {})

	for t, side_number in helper.get_sides(cfg) do
		-- wesnoth.message("WML", string.format("store side %u", side_number))
		local side_store = string.format("%s[%u]", variable, array_index)

		wesnoth.set_variable(side_store, {})

		wesnoth.wml_actions.store_side {
			variable = side_store, side = side_number
		}
		wesnoth.wml_actions.store_unit {
			kill = true,
			variable = side_store .. ".units", { "filter", { side = side_number } }
		}
		wesnoth.wml_actions.modify_side {
			controller = "null", income = -2, gold = 0, village_gold = 0,
			hidden = true, side = side_number
		}

		array_index = array_index + 1
	end
end

function wesnoth.wml_actions.unserialize_and_activate_sides(cfg)
	local variable = cfg.variable or helper.wml_error("[unserialize_and_activate_sides]: Missing variable!")

	local data_set = helper.get_variable_array(variable)

	for index, side_data in ipairs(data_set) do
		wesnoth.wml_actions.modify_side {
			side = side_data.side, gold = side_data.gold, village_gold = side_data.village_gold,
			income = side_data.income, controller = side_data.controller, hidden = side_data.hidden
		}

		local units = helper.get_variable_array(variable .. string.format("[%u].units", index - 1))

		for uindex, container in ipairs(units) do
			wesnoth.wml_actions.unstore_unit {
				variable = string.format("%s[%u].units[%u]", variable, index - 1, uindex - 1),
				find_vacant = true
			}
		end
	end
end

-----------
-- E2S11 --
-----------

function wesnoth.wml_actions.store_unit_can_move_on_current_terrain(cfg)
	local var = cfg.variable or helper.wml_error("[store_unit_can_move_on_current_terrain]: Missing variable!")
	local u = wesnoth.get_units(cfg)[1]

	if not u then
		helper.wml_error("[store_unit_can_move_on_current_terrain]: Could not match anything!")
	end

	wesnoth.set_variable(var,
		(wesnoth.unit_movement_cost(u, wesnoth.get_terrain(u.x, u.y)) < u.max_moves))
end

