---
-- Fake NPC AI logic.
---

local helper = wesnoth.require "lua/helper.lua"

---
-- [npc_bird_behavior]
--     types=... # list of unit types that will be considered for movement
--     side=...  # side whose units will be considered; defaults to the current
--               # playing side
--     x1,y1=... # top left corner of the movement area
--     x2,y2=... # bottom right corner of the movement area
-- [/npc_bird_behavior]
---
function wesnoth.wml_actions.npc_bird_behavior(cfg)
	local map_w, map_h, map_border = wesnoth.get_map_size()

	local function do_error(msg)
		helper.wml_error("[npc_bird_behavior]: " .. msg)
	end

	if map_border ~= 1 then
		do_error("maps with border_size != 1 are not supported yet")
	end

	local function on_board(x, y)
		return (x > 0 and x <= map_w) and (y > 0 and y <= map_h)
	end

	local types = cfg.types or do_error("no unit types specified")

	local side_num = cfg.side or wesnoth.current.side

	local x1 = cfg.x1 or 1
	local y1 = cfg.y1 or 1

	local x2 = cfg.x2 or map_w
	local y2 = cfg.y2 or map_h

	if not on_board(x1,y1) then
		do_error(string.format("(x1, y1) is (%d, %d), which is not on map (%d x %d)", x1, y1, map_w, map_h))
	end
	if not on_board(x2,y2) then
		do_error(string.format("(x2, y2) is (%d, %d), which is not on map (%d x %d)", x2, y2, map_w, map_h))
	end

	local function in_npc_region(x, y)
		return (x >= x1 and x <= x2) and (y >= y1 and y <= y2)
	end

	-- wesnoth.message(string.format("moving birds in area ((%d, %d), (%d, %d))", x1, y1, x2, y2))

	--
	-- Store required units
	--

	local npcs = wesnoth.get_units {
		type = types, side = side_num,
		x = string.format("1-%d", map_w),
		y = string.format("1-%d", map_h)
	}

	for k, npc in ipairs(npcs) do
		if not in_npc_region(npc.x, npc.y) then
			wesnoth.wml_actions.kill {
				x = npc.x, y = npc.y,
				animate = false, fire_event = true
			}
		elseif npc.moves > 0 then
			local move_steps = npc.moves
			local oob = false
			local endpoint = { x = npc.x, y = npc.y }
			local path = { x = npc.x, y = npc.y, direction = safe_random("n,s,ne,nw,se,sw") }

			-- TODO: quit the course when encountering a unit?
			--
			-- Perhaps we should also use proper pathfinding instead of
			-- blindly testing each individual hex in the chosen direction,
			-- but we'd somehow need to override movement costs for units
			-- in impassable terrain (e.g. Shaxthal Worms in cave wall,
			-- regular birds on Impassable mountains).

			for j = 0, move_steps, 1 do
				if oob then break end

				local target = wesnoth.get_locations({
					{ "filter_adjacent_location", {
						adjacent = "-" .. path.direction,
						x = endpoint.x,
						y = endpoint.y
					} }
				})[1]

				if (not target) or (not in_npc_region(target[1], target[2])) then
					oob = true
				else
					path.x = path.x .. string.format(",%d", target[1])
					path.y = path.y .. string.format(",%d", target[2])

					endpoint.x = target[1]
					endpoint.y = target[2]
					npc.moves = npc.moves - 1
				end
			end

			-- Move the bird

			wesnoth.extract_unit(npc)

			-- wesnoth.message(string.format("x = %s; y = %s", path.x, path.y))

			local npc_cfg = npc.__cfg

			wesnoth.wml_actions.move_unit_fake {
				type = npc_cfg.type,
				gender = npc_cfg.gender,
				variation = npc_cfg.variation,
				image_mods = npc.image_mods,
				side = npc_cfg.side,
				x = path.x,
				y = path.y
			}

			-- Birds found moving out of their movement area
			-- are not restored

			if not oob then
				npc.x, npc.y = wesnoth.find_vacant_tile(endpoint.x, endpoint.y)
				npc.facing = path.direction

				wesnoth.put_unit(npc)
			end

			-- TODO: fire moveto or death events accordingly

			wesnoth.wml_actions.redraw {}

		end
	end

end
