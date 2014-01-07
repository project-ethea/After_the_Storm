---
-- Unit spawner implementation details. No user-serviceable parts here.
---

local T = helper.set_wml_tag_metatable {}

local function dbg(msg)
	wesnoth.fire("wml_message", { logger = "log", message = "[AtS] spawner.lua: " .. msg })
end

---
-- Implementation detail.
---
function wesnoth.wml_actions.run_spawn_controller(cfg)
	local ctx = wesnoth.current.event_context
	local u = wesnoth.get_unit(ctx.x1, ctx.y1)
	local uv = u.variables

	local respawn_event = uv.spawner_event
	local respawn_turn = wesnoth.current.turn + uv.spawner_turns

	if uv.spawner_turns <= 0 and uv.spawner_respawn then
		dbg(string.format("<CTL> fire '%s' now", respawn_event))

		wesnoth.fire("kill", {
			x = ctx.x1,
			y = ctx.y1,
			fire_event = false,
			animate = false
		})

		wesnoth.fire_event(respawn_event)
	else
		dbg(string.format("<CTL> fire '%s' on turn %d", respawn_event, respawn_turn))

		wesnoth.fire("event", {
			name = string.format("turn %d", respawn_turn),
			first_time_only = true,
			T.filter_condition {
				T.variable {
					name = "spawner_controller_enabled",
					boolean_equals = true
				}
			},

			T.fire_event {
				name = respawn_event
			}
		})
	end
end

---
-- Implementation detail.
---
function wesnoth.wml_actions.spawner_spawn(cfg)
	local function do_error(msg)
		helper.wml_error("[spawner_spawn]: " .. msg)
	end

	local side = cfg.side or do_error("side number missing")
	local x = cfg.x or do_error("X position missing")
	local y = cfg.y or do_error("Y position missing")

	local can_respawn = cfg.can_respawn
	if can_respawn == nil then can_respawn = true end

	local respawn_turns = 0
	if can_respawn then
		respawn_turns = cfg.respawn_turns or do_error("respawn_turns missing or zero and can_respawn is true")
	end

	cfg = helper.literal(cfg)

	-- Delete non-[unit] attributes.
	cfg.can_respawn = nil
	cfg.respawn_turns = nil

	cfg.generate_name = true
	cfg.random_traits = true
	cfg.upkeep = "free"

	local uvars = {
		-- Used by a WML event handler.
		spawner_respawn = can_respawn,
		spawner_event = string.format("respawn:S%dX%dY%d", side, x, y),
		spawner_turns = respawn_turns
	}

	if can_respawn then
		local spawn_once_value = safe_random("0..100") % safe_random("23,33,41,73")

		if spawn_once_value == 0 then
			uvars.spawner_respawn = false
		end
	end

	table.insert(cfg, T.variables(uvars))

	if cfg.facing == nil then cfg.facing = "n,ne,nw,s,se,sw" end

	-- Randomize unit type and facing if provided as comma-separated lists.
	cfg.type = safe_random(cfg.type)
	cfg.facing = safe_random(cfg.facing)

	dbg(string.format("respawn S: %d, X: %d, Y: %d, T: %s, F: %s, R: %d %d",
		side, x, y, cfg.type, cfg.facing, ((uvars.spawner_respawn and 1) or 0), respawn_turns))

	-- Run [unit].
	--dbg(wesnoth.debug(wesnoth.tovconfig(cfg)))
	wesnoth.fire("unit", cfg)
end
