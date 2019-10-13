---
-- Lua WML actions that are intended specifically for use in the After the Storm
-- campaign.
---

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
		local r = helper.rand(string.format("1..%d", #locs))
		local x, y = locs[r][1], locs[r][2]
		spawn_loyal_player_unit("Skeleton", x, y)
		table.remove(locs, r)
	end

	for i = 1, num_ghosts do
		if #locs == 0 then
			return
		end
		local r = helper.rand(string.format("1..%d", #locs))
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

	wml.variables[variable] = {}

	for t, side_number in helper.get_sides(cfg) do
		-- wesnoth.message("WML", string.format("store side %u", side_number))
		local side_store = string.format("%s[%u]", variable, array_index)

		wml.variables[side_store] = {}

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

	local data_set = wml.array_access.get(variable)

	for index, side_data in ipairs(data_set) do
		wesnoth.wml_actions.modify_side {
			side = side_data.side, gold = side_data.gold, village_gold = side_data.village_gold,
			income = side_data.income, controller = side_data.controller, hidden = side_data.hidden
		}

		local units = wml.array_access.get(variable .. string.format("[%u].units", index - 1))

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
		-- Could not match anything
		return
	end

	wml.variables[var] = (wesnoth.unit_movement_cost(u, wesnoth.get_terrain(u.x, u.y)) < u.max_moves)
end

-------------
-- E3S7A.2 --
-------------

function wesnoth.wml_actions.store_vacant_spawn_location(cfg)
	local variable = cfg.variable or "location"
	local direction = cfg.direction or helper.wml_error("[store_vacant_spawn_location]: Missing direction!")
	local x = tonumber(cfg.x)
	local y = tonumber(cfg.y)

	if not (x and y) then
		helper.wml_error("[store_vacant_spawn_location]: x,y must describe an on-map location!")
	end

	local radius = tonumber(cfg.radius)

	if not radius or radius < 1 then
		helper.wml_error("[store_vacant_spawn_location]: Radius must be greater than 1!")
	end

	local w, h = wesnoth.get_map_size()

	for k = 1, radius do
		local loc = wesnoth.get_locations({
			-- On map.
			x = string.format("1-%d", w),
			y = string.format("1-%d", h),
			-- Not impassable.
			{ "not", {
				terrain = "X*,X*^*,*^X*",
			} },
			-- Adjacent to our source hex.
			{ "filter_adjacent_location", {
				adjacent = '-' .. direction,
				x = x,
				y = y,
			} }
		})[1]

		if loc then
			x = loc[1]
			y = loc[2]
		else
			x = 0
			y = 0
			break
		end
	end

	wml.variables[variable .. '.x'] = x
	wml.variables[variable .. '.y'] = y
end

----------
-- E3S9 --
----------

local location_set = wesnoth.require("lua/location_set.lua")

function wesnoth.wml_actions.dreamwalk(cfg)
	local dst_x = cfg.to_x
	local dst_y = cfg.to_y

	local map_w, map_h, map_b = wesnoth.get_map_size()

	if dst_x <= 0 or dst_x > map_w or dst_y <= 0 or dst_y > map_h then
		helper.wml_error("[marsap]: Destination invalid or out of map bounds!")
	end

	local u = wesnoth.get_units(cfg)[1] or helper.wml_error("[marsap]: No matching units!")

	-- We use a fixed reach value for visibility calculation. It doesn't take
	-- into account vision, jamming, or movement costs, but that's okay for our
	-- use case, right?
	local reach = u.max_moves

	local src_x, src_y = u.x, u.y
	if not src_x or not src_y then
		helper.wml_error("[marsap]: Bad source location!")
	end

	-- Compute a set of locations to remove shroud from so that we don't pass
	-- the same coordinates more than once.
	-- FIXME: Probably could optimize the radius search somehow.

	local path = wesnoth.find_path(src_x, src_y, dst_x, dst_y)
	local region = location_set.of_pairs(path)
	local rawsize = 0

	for n, loc in ipairs(path) do
		local subregion = wesnoth.get_locations { x = loc[1], y = loc[2], radius = reach }
		region:union(location_set.of_pairs(subregion))
		rawsize = rawsize + #subregion

		--[[ DEBUG
		wesnoth.wml_actions.item {
			x = loc[1], y = loc[2],
			image = "terrain/alphamask.png~PAL(000000>FF00FF)"
	    }
		--]]
	end

	wprintf(W_INFO, "[dreamwalk]: TILE COUNT RAW %d OPT %d", rawsize, region:size())

	local label = "TEMP_unshroud_region"

	region:to_wml_var(label)
	-- wesnoth.wml_actions.inspect {}
	wesnoth.wml_actions.remove_shroud { side = 1, find_in = label }
	wml.variables[label] = nil
	wesnoth.wml_actions.redraw { clear_shroud = true }

	wesnoth.wml_actions.move_unit {
		{ "filter", { id = u.id } },
		to_x = dst_x, to_y = dst_y,
		-- Might be needed for this sequence.
		check_passability = false
	}
end
