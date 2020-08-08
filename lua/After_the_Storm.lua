---
-- Lua WML actions that are intended specifically for use in the After the Storm
-- campaign.
---

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

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
		local r = helper.rand(("1..%d"):format(#locs))
		local x, y = locs[r][1], locs[r][2]
		spawn_loyal_player_unit("Skeleton", x, y)
		table.remove(locs, r)
	end

	for i = 1, num_ghosts do
		if #locs == 0 then
			return
		end
		local r = helper.rand(("1..%d"):format(#locs))
		local x, y = locs[r][1], locs[r][2]
		spawn_loyal_player_unit("Ghost", x, y)
		table.remove(locs, r)
	end
end

-----------
-- E2S11 --
-----------

function wesnoth.wml_actions.animate_control_spires(cfg)
	local units = wesnoth.get_units(cfg)

	if not units then
		return
	end

	local animator = wesnoth.create_animator()

	for i, u in ipairs(units) do
		local loc = wesnoth.get_locations({
			{ "filter_adjacent_location", {
				x = u.x, y = u.y, adjacent = "-n"
			}}
		})[1]

		local dir = wesnoth.map.get_relative_dir(u.x, u.y, loc[1], loc[2])
		u.facing = dir

		animator:add(u, "portal beam", "hits", {
			facing = wesnoth.map.get_direction(u.x, u.y, dir),
			with_bars = true,
		})
	end

	animator:run()
	animator:clear()
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
			x = ("1-%d"):format(w),
			y = ("1-%d"):format(h),
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

function wesnoth.wml_actions.final_boss_hp_tint(cfg)
	-- NOTE: This is not a SUF. In the future the id= attribute may have more
	-- advanced semantics, different from an actual SUF.
	local unit_id = cfg.id or
		helper.wml_error("[screen_hp_tint]: No unit id specified")
	local u = wesnoth.get_units({ id = unit_id })[1]

	if not u then
		wprintf(W_WARN, "[screen_hp_tint]: Unit disappeared early?")
		return
	end

	--
	-- Darken the screen on the green and blue channels (the
	-- DARKEN_RED_SCREEN macro) as follows:
	--
	-- HP/MAX_HP = 1.0 -> (R, G, B) = (0, -10, -10)
	-- ...
	-- HP/MAX_HP = 0.0 -> (R, G, B) = (0, -60, -60)
	--

	local hp_ratio = u.hitpoints / u.max_hitpoints
	local s = helper.round(-10 - 50 * (1.0 - hp_ratio))

	wprintf(W_DBG, "[screen_hp_tint] HP: %d/%d (%.1f) -> %d", u.hitpoints, u.max_hitpoints, hp_ratio, s)

	wesnoth.wml_actions.color_adjust { red = 0, green = s, blue = s }
end

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

-----------
-- E3S10 --
-----------

function wesnoth.wml_actions.push_units_away_from(cfg)
	local center = { x = cfg.from_x, y = cfg.from_y }
	if not center.x or not center.y then
		helper.wml_error("[puaf]: Missing center coordinates")
	end

	local suf = wml.get_child(cfg, "filter") or
		helper.wml_error("[puaf]: Missing SUF")

	local units = wesnoth.get_units(suf)

	if not units then
		wprintf(W_WARN, "[puaf]: No units matched SUF (???)")
		return
	end

	local map_w, map_h = wesnoth.get_map_size()

	local function location_is_on_map(pos)
		return pos and pos[1] >= 1 and pos[2] >= 1 and pos[1] <= map_w and pos[2] <= map_h
	end

	local function unit_can_stand_on_location(pos, unit)
		local new_pos = {0, 0}
		new_pos[1], new_pos[2] = wesnoth.find_vacant_tile(pos[1], pos[2], unit)
		return new_pos[1] == pos[1] and new_pos[2] == pos[2]
	end

	for i, u in ipairs(units) do
		local pos = { u.x, u.y }
		local dir = wesnoth.map.get_relative_dir(pos, center) or "sw"
		local new_pos = wesnoth.map.get_direction(pos, dir, -1)

		if location_is_on_map(new_pos) and unit_can_stand_on_location(new_pos, u) then
			-- NOTE: This is redundant but you can never be too safe, right?
			if wesnoth.get_unit(new_pos[1], new_pos[2]) then
				helper.wml_error("[puaf]: Wesnoth is on drugs, call an ambulance")
			end

			wprintf(W_DBG, "[puaf]: Move unit %s -%s (%d,%d) -> (%d,%d)", u.id, dir, pos[1], pos[2], new_pos[1], new_pos[2])

			u:extract()
			u:to_map(new_pos[1], new_pos[2])
		else
			wprintf(W_DBG, "[puaf]: Can't push unit %s -%s (%d,%d) -> (%d,%d), destination is occupied", u.id, dir, pos[1], pos[2], new_pos[1], new_pos[2])
		end
	end
end

-- DEBUG ONLY

function wesnoth.wml_actions.dbg_test_variation(cfg)
	local new_variation = cfg.variation_name

	local units = wesnoth.get_units({ side=2, canrecruit=true })
	if not units then
		return
	end

	local u = units[1]

	wesnoth.wml_actions.object {
		silent = true,
		{ "filter", {
			x = u.x, y = u.y
		} },
		{ "effect", {
			apply_to = "variation",
			name = new_variation
		} }
	}
end

-------------
-- Globals --
-------------

local SUF_GHOST_UNITS = {
	type = "Ghost,Wraith,Spectre,Shadow,Nightgaunt",
	side = 1,
}

function wesnoth.wml_conditionals.player_ghost_limit_reached(cfg)
	--if not wesnoth.get_unit("Zynara") then
	--	return false
	--end

	local variable = cfg.variable or helper.wml_error("[cpgl] Missing required variable= attribute")
	local limit = cfg.limit or helper.wml_error("[cpgl] Missing required limit= attribute")

	local count = #wesnoth.get_units(SUF_GHOST_UNITS) + #wesnoth.get_recall_units(SUF_GHOST_UNITS)

	wml.variables[variable] = count

	return count > limit
end

local function random_map_location()
	local locs = wesnoth.get_locations { include_borders = false }
	local r = wesnoth.random(#locs)
	return locs[r][1], locs[r][2]
end

function wesnoth.wml_actions.player_ghost_trap()
	local wild_ghosts_side = wml.variables.wild_ghosts_side or 2

	local recall_or_map = wesnoth.random(2)

	local on_map = wesnoth.get_units(SUF_GHOST_UNITS)
	local off_map = wesnoth.get_recall_units(SUF_GHOST_UNITS)

	local r, u = 0, nil

	if recall_or_map == 2 and #off_map > 0 then
		r = wesnoth.random(#off_map) or helper.wml_error("[pgt] bad off-map selection")
		u = off_map[r]
	else
		r = wesnoth.random(#on_map) or helper.wml_error("[pgt] bad on-map selection")
		u = on_map[r]
	end

	-- Enable the wild ghosts side if it's not enabled already.
	wesnoth.sides[wild_ghosts_side].controller = "ai"

	if recall_or_map == 2 then
		-- Recall the unit immediately so the player doesn't have the chance to
		-- preemptively dismiss it.
		local recall_x, recall_y = random_map_location()
		local recall_id = u.id

		wesnoth.wml_actions.recall { id = recall_id, x = recall_x, y = recall_y, show = false }
		wesnoth.get_unit(recall_id).side = wild_ghosts_side
	else
		-- Transfer the unit to its new side at the end of the player's turn.
		local T = wml.tag
		wesnoth.wml_actions.event {
			name = ("side %d turn end"):format(u.side),

			T.modify_unit {
				T.filter {
					id = u.id
				},
				side = wild_ghosts_side
			}
		}
	end
end

function wesnoth.wml_actions.seismic_impact(cfg)
	local T = wml.tag
	local ctx = wesnoth.current.event_context

	--
	-- BIG FAT NOTE: This action is not entirely self-contained. An ancillary
	-- event to handle the stunned status effect is needed and is not injected
	-- by the action.
	--
	-- Additionally, the source and target are hardcoded to be the primary and
	-- secondary unit, respectively, along with their used attacks. You will
	-- need to normalize the primary/secondary selections using event
	-- dispatching since they swap places during an attack sequence.
	--
	-- ALSO, this is strictly-speaking a crowd-control weapon special. However,
	-- since it cannot be used by the player, the CC immunity check isn't made
	-- here since it's assumed to only affect player units, which are never
	-- counted as immune to CC.
	--

	local src = wesnoth.get_unit(ctx.x1, ctx.y1)
	local src_atk = wml.get_child(ctx, "weapon")

	local dst = wesnoth.get_unit(ctx.x2, ctx.y2)
	local dst_atk = wml.get_child(ctx, "second_weapon")

	--wesnoth.wml_actions.inspect {}

	-- 25% chance to return true
	local function confirm_status_inflict()
		return helper.rand("A,A,A,A,B,B,B,B,C,C,C,C,D,D,D,D") == "A"
	end

	local ui_sound_played = false

	-- Applies the weapon special's effects on a singular target
	local function apply_seismic_status(u)
		local status_changed = false

		if not u.status.stunned then
			u.status.stunned = true
			status_changed = true
		end

		if not u.status.slowed then
			u.status.slowed = true
			status_changed = true
		end

		wesnoth.add_modification(u, "object", {
			id = "seismic_effect_obj",
			take_only_once = false,
			silent = true,
			duration = "turn end",

			T.effect {
				apply_to = "image_mod",
				add = "CS(50,50,0)"
			},
			T.effect {
				apply_to = "zoc",
				value = false
			}
		})

		-- Only play sounds once during this event, otherwise weird things may
		-- happen (such as running into the concurrent sound samples limit)

		if status_changed and not ui_sound_played then
			wesnoth.play_sound("slowed.wav")
			ui_sound_played = true
		end

		wesnoth.float_label(u.x, u.y, ("<span foreground='#c4c480'>%s</span>"):format(_("seism")))
	end


	local function impact_additional_target(u, amount)
		-- Splash damage
		wesnoth.wml_actions.harm_unit {
			T.filter {
				x = u.x, y = u.y
			},
			T.filter_attack(src_atk),
			alignment = src.__cfg.alignment,
			damage_type = src_atk.type,
			amount = src_atk.damage * 0.75,
			kill = false,
			experience = true,
			fire_event = true,
			animate = false,
			delay = 0
		}

		if confirm_status_inflict() then
			apply_seismic_status(u)
		end
	end

	-- Apply status effects to the original target first

	if confirm_status_inflict() then
		apply_seismic_status(dst)
	end

	-- Find additional targets

	local splash_units = wesnoth.get_units {
		T.filter_adjacent { x = dst.x, y = dst.y },
		T.filter_side { T.enemy_of { side = src.side } }
	}

	if not splash_units then
		return
	end

	for i, splash_u in ipairs(splash_units) do
		impact_additional_target(splash_u)
	end
end
