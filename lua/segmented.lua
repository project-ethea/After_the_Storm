--
-- Segmented scenario library
--
-- After the Storm
-- Copyright (C) 2012 - 2023 by Iris Morelle <shadowm@wesnoth.org>
--
-- See COPYING for usage terms.
--

local T = wml.tag

local function human_controlled_sides()
	-- TODO: Make configurable in WML
	return "1"
end

local function current_floor()
	return wml.variables["floor_config.current"]
end

local function dispatch_floor_events(action)
	wprintf(W_INFO, "dispatching floor events for action %s on floor %d", action, current_floor())
	wesnoth.game_events.fire(("%s floor"):format(action))
	wesnoth.game_events.fire(("%s floor %d"):format(action, current_floor()))
end

function wesnoth.wml_actions.change_floor(cfg)
	local config = wml.variables.floor_config
	local num_floors = wml.variables["floor_config.floor.length"]
	local new_floor_num = tonumber(cfg.floor_number or 0)

	if not new_floor_num or new_floor_num > num_floors then
		wml.error(("Attempted to enter floor %d, which is out of range ([1..%d])"):format(new_floor_num, num_floors))
	end

	local floor = wml.variables[("floor_config.floor[%d]"):format(new_floor_num - 1)]
	local schedule = wml.get_child(floor, "schedule")
	local playlist = wml.get_child(floor, "music_playlist")
	-- If no floor-specific schedule was specified use the initial schedule
	-- recorded in [floor_config][default_time] during prestart.
	if not wml.get_child(schedule, "time") then
		schedule = { T.time(wml.get_child(config, "default_time")) }
	end

	wesnoth.wml_actions.lock_view {}

	dispatch_floor_events("leave")

	wml.variables["floor_config.current"] = new_floor_num

	wesnoth.wml_actions.clear_map_labels {}
	wesnoth.wml_actions.remove_item {}

	wesnoth.wml_actions.kill {
		animate    = false,
		fire_event = false,
		-- Only kill on-map units not belonging to human-controlled sides.
		T.filter_location {},
		T["not"] {
			side = human_controlled_sides(),
		},
	}

	wesnoth.wml_actions.replace_map {
		-- TODO: map_file support
		map    = floor.map_data,
		shrink = true,
		expand = true,
	}

	wesnoth.wml_actions.replace_schedule(schedule)

	dispatch_floor_events("setup")

	if playlist then
		for music_cfg in wml.child_range(playlist, "music") do
			wesnoth.wml_actions.music(music_cfg)
		end
	end

	dispatch_floor_events("enter")

	wesnoth.wml_actions.unlock_view {}
end
