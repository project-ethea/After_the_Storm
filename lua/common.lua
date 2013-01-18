---
-- General-purpose Lua WML actions.
---

local helper = wesnoth.require "lua/helper.lua"

-- helper.round() is not implemented in version 1.10.x.
if wesnoth.compare_versions(wesnoth.game_config.version, '<', '1.11.0') then
	function helper.round(number)
		-- code converted from util.hpp, round_portable function
		-- round half away from zero method
		if number >= 0 then
			number = math.floor( number + 0.5 )
		else
			number = math.ceil ( number - 0.5 )
		end

		return number
	end
end

function safe_random(arg)
	wesnoth.fire("set_variable", {
		name = "temp_ats_lua_random",
		rand = arg,
	})

	local r = wesnoth.get_variable("temp_ats_lua_random")
	wesnoth.set_variable("temp_ats_lua_random")

	return r
end

-- NOTE: taken from data/lua/wml-tags.lua:
-- "when using these, make sure that nothing can throw over the call to end_var_scope"
local function start_var_scope(name)
	local var = helper.get_variable_array(name) --containers and arrays
	if #var == 0 then var = wesnoth.get_variable(name) end --scalars (and nil/empty)
	wesnoth.set_variable(name)
	return var
end
local function end_var_scope(name, var)
	wesnoth.set_variable(name)
	if type(var) == "table" then
		helper.set_variable_array(name, var)
	else
		wesnoth.set_variable(name, var)
	end
end

---
-- Assigns a given variable (presumed to be a direction value)
-- the opposite of its current contents. If the variable doesn't
-- seem to be a direction value, SE is used, setting it to NW.
--
-- [invert_direction]
--     variable="direction"
-- [/invert_direction]
---
function wesnoth.wml_actions.invert_direction(cfg)
	local variable = cfg.variable or "direction"

	local dir = wesnoth.get_variable(variable)

	if dir == "s" then
		dir = "n"
	elseif dir == "sw" then
		dir = "ne"
	elseif dir == "nw" then
		dir = "se"
	elseif dir == "n" then
		dir = "n"
	elseif dir == "ne" then
		dir = "sw"
	else -- if dir == "se" then
		dir = "nw"
	end

	wesnoth.set_variable(variable, dir)
end

---
-- Gets the relative direction of a source hex to a target hex.
-- Useful to determine in which direction a unit should be facing
-- (from the source) to look at another unit (at the target).
--
-- NOTE: This initial implementation only handles southwest and
-- southeast. The C++ code handling these calculations isn't exposed
-- to Lua yet, but direction.lua provides an attempt at translating
-- it.
--
-- [store_direction]
--     from_x,from_y= ...
--     to_x,to_y= ...
--     variable="direction"
-- [/store_direction]
--
-- Or:
--
-- [store_direction]
--     [from]
--         ... SLF ...
--     [/from]
--     [to]
--         ... SLF ...
--     [/to]
--     variable="direction"
-- [/store_direction]
---
function wesnoth.wml_actions.store_direction(cfg)
	local from_slf = helper.get_child(cfg, "from")
	local to_slf = helper.get_child(cfg, "to")

	local a = { x = cfg.from_x, y = cfg.from_y }
	local b = { x = cfg.to_x  , y = cfg.to_y   }

	if from_slf then
		a.x = wesnoth.get_locations(from_slf)[1][1]
		a.y = wesnoth.get_locations(from_slf)[1][2]
	end
	if to_slf then
		b.x = wesnoth.get_locations(to_slf)[1][1]
		b.y = wesnoth.get_locations(to_slf)[1][2]
	end

	if not a.x or not a.y or not b.x or not b.y then
		helper.wml_error "[store_direction] missing coordinate!"
	end

	local variable = cfg.variable or "direction"

	-- local facing = loc_relative_direction(b, a) or "sw"
	-- wesnoth.set_variable(variable, facing)

	if a.x < b.x then
		wesnoth.set_variable(variable, "se")
	else
		wesnoth.set_variable(variable, "sw")
	end
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
-- To store ids from recall lists, x and y must be either absent
-- or set to "recall" in the base filter (not subfilters!).
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
	local var = cfg.variable or "units"
	local idx = 0
	if cfg.mode == "append" then
		idx = wesnoth.get_variable(var .. ".length")
	else
		wesnoth.set_variable(var)
	end

	for i, u in ipairs(wesnoth.get_units(filter)) do
		wesnoth.set_variable(string.format("%s[%d].id", var, idx), u.id)
		idx = idx + 1
	end

	if (not filter.x or filter.x == "recall") and (not filter.y or filter.y == "recall") then
		for i, u in ipairs(wesnoth.get_recall_units(filter)) do
			wesnoth.set_variable(string.format("%s[%d].id", var, idx), u.id)
			idx = idx + 1
		end
	end
end

---
-- Places an item in the map. Just like [item], but without the implicit [redraw].
-- NOTE: items placed this way are lost upon loading from a saved game.
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

---
-- Matches a standard location filter and stores the resultant coordinates
-- list in a container with two attributes that are comma-separated lists, .x and .y.
--
-- [simplify_location_filter]
--     ... SLF ...
--     variable="location"
-- [/simplify_location_filter]
---
function wesnoth.wml_actions.simplify_location_filter(cfg)
	local var = cfg.variable or "location"
	local locs = wesnoth.get_locations(cfg)
	local xstr, ystr = "", ""

	wesnoth.set_variable(var)

	for i, loc in ipairs(locs) do
		if i > 1 then
			xstr = xstr .. string.format(",%d", loc[1])
			ystr = ystr .. string.format(",%d", loc[2])
		else
			xstr = string.format("%d", loc[1])
			ystr = string.format("%d", loc[2])
		end
	end

	wesnoth.set_variable(var .. ".x", xstr)
	wesnoth.set_variable(var .. ".y", ystr)
end

---
-- Simpler alternative to the harm_unit action with less options, which
-- uses animate_unit.animate for concurrent animations. It can only work with
-- single attackers and defenders.
---
function wesnoth.wml_actions.animate_attack(cfg)
	local attacker_filter = helper.get_child(cfg, "filter_second") or helper.wml_error("[animate_attack] missing required [filter_second] tag")
	local defender_filter = helper.get_child(cfg, "filter") or helper.wml_error("[animate_attack] missing required [filter] tag")
	local weapon_filter = helper.get_child(cfg, "filter_attack") or helper.wml_error("[animate_attack] missing required [filter_attack] tag")

	-- we need to use shallow_literal field, to avoid raising an error if $this_unit (not yet assigned) is used
	if not cfg.__shallow_literal.amount then helper.wml_error("[harm_unit] has missing required amount= attribute") end

	local attacker = wesnoth.get_units(attacker_filter)[1]
	if not attacker then
		helper.wml_error("[animate_attack]: Could not match any attackers")
	end

	local defender = wesnoth.get_units(defender_filter)[1]
	if not defender then
		helper.wml_error("[animate_attack]: Could not match any defenders")
	end

	local _ = wesnoth.textdomain "wesnoth"
	-- #textdomain wesnoth

	local this_unit = start_var_scope("this_unit")

	wesnoth.set_variable("this_unit") -- clearing this_unit
	wesnoth.set_variable("this_unit", defender.__cfg) -- cfg field needed

	local animate = cfg.animate
	local fire_event = cfg.fire_event
	local amount = tonumber(cfg.amount)
	local kill = cfg.kill
	-- NOTE: excluded from this implementation
	-- local experience = cfg.experience

	-- NOTE: taken from data/lua/wml-tags.lua:
	-- "the two functions below are taken straight from the C++ engine, util.cpp and actions.cpp, with a few unuseful parts removed
	-- may be moved in helper.lua in 1.11"
	local function round_damage( base_damage, bonus, divisor )
		local rounding
		if base_damage == 0 then return 0
		else
			if bonus < divisor or divisor == 1 then
				rounding = divisor / 2 - 0
			else
				rounding = divisor / 2 - 1
			end
			return math.max( 1, math.floor( ( base_damage * bonus + rounding ) / divisor ) )
		end
	end
	local function calculate_damage( base_damage, alignment, tod_bonus, resistance )
		local damage_multiplier = 100
		if alignment == "lawful" then
			damage_multiplier = damage_multiplier + tod_bonus
		elseif alignment == "chaotic" then
			damage_multiplier = damage_multiplier - tod_bonus
		elseif alignment == "liminal" then
			damage_multiplier = damage_multiplier - math.abs( tod_bonus )
		else -- neutral, do nothing
		end
		damage_multiplier = damage_multiplier * resistance -- at this point, a resistance_modifier can be added, as asked by fendrin
		local damage = round_damage( base_damage, damage_multiplier, 10000 ) -- if harmer.status.slowed, this may be 20000 ?
		return damage
	end
	
	-- Calculate damage first to determine if the defender dies or not

	local damage = calculate_damage(
		amount, (cfg.alignment or "neutral"),
		wesnoth.get_time_of_day( { defender.x, defender.y, true } ).lawful_bonus,
		wesnoth.unit_resistance( defender, cfg.damage_type or "dummy" )
	)

	local hit_animation_type = true

	if defender.hitpoints <= damage then
		if kill == false then
			damage = defender.hitpoints - 1
		else
			damage = defender.hitpoints
			hit_animation_type = "kill"
		end
	end

	local text = string.format("%d%s", damage, "\n")
	local add_tab = false
	local gender = defender.__cfg.gender

	-- NOTE: also from data/lua/wml-tags.lua
	local function set_status(name, male_string, female_string, sound)
		if not cfg[name] or defender.status[name] then return end
		if gender == "female" then
			text = string.format("%s%s%s", text, tostring(female_string), "\n")
		else
			text = string.format("%s%s%s", text, tostring(male_string), "\n")
		end

		defender[name] = true
		add_tab = true

		if animate and sound then -- for unhealable, that has no sound
			wesnoth.play_sound(sound)
		end
	end

	if not defender.status.not_living then
		set_status("poisoned", _"poisoned", _"female^poisoned", "poison.ogg")
	end
	set_status("slowed", _"slowed", _"female^slowed", "slowed.wav")
	set_status("petrified", _"petrified", _"female^petrified", "petrified.ogg")
	set_status("unhealable", _"unhealable", _"female^unhealable")

	if add_tab then
		text = string.format("%s%s", "\t", text)
	end

	-- HACK: do not display floating label when
	-- the inflicted damage is zero

	if damage == 0 then
		text = ""
	end

	if animate then
		wesnoth.scroll_to_tile(attacker.x, attacker.y, true)
		wesnoth.wml_actions.animate_unit( {
			flag = "attack",
			hits = hit_animation_type,
			with_bars = true,
			{ "filter", { id = attacker.id } },
			{ "primary_attack", weapon_filter },
			{ "facing", { x = defender.x, y = defender.y } },
			{ "animate", {
				flag = "defend",
				{ "filter", { id = defender.id } },
				{ "primary_attack", weapon_filter },
				text = text,
				red = 255,
				with_bars = true,
				hits = hit_animation_type,
			} }
		} )
	else
		wesnoth.float_label( defender.x, defender.y, string.format( "<span foreground='red'>%s</span>", text ) )
	end

	defender.hitpoints = defender.hitpoints - damage

	if kill ~= false and defender.hitpoints <= 0 then
		wesnoth.wml_actions.kill({ id = defender.id, animate = animate, fire_event = fire_event })
	end

	wesnoth.wml_actions.redraw {}

	wesnoth.set_variable ( "this_unit" ) -- clearing this_unit
	end_var_scope("this_unit", this_unit)
end

---
-- Creates a unit that's initially hidden from view as if [hide_unit]
-- was used on it.
--
-- This is necessary since [unit] followed by [hide_unit] allows the unit
-- to be displayed for an instant.
--
-- The syntax is identical to [unit].
---

function wesnoth.wml_actions.hidden_unit(cfg)
	local u = wesnoth.create_unit(cfg)
	u.hidden = true
	wesnoth.put_unit(u)
end

---
-- Counts the amount of matching units.
--
-- [count_units]
--     ... SUF ...
--     variable=unit_count
-- [/count_units]
---

function wesnoth.wml_actions.count_units(cfg)
	local units = wesnoth.get_units(cfg)
	local varname = cfg.variable or "unit_count"

	if units == nil then
		wesnoth.set_variable(varname, 0)
	else
		wesnoth.set_variable(varname, #units)
	end
end

---
-- Retrieves the given unit's portrait file path, or the
-- fallback image with TC applied on it if there's no portrait
-- defined.
--
-- [store_unit_portrait]
--     ... SUF ...
--     variable=unit_portrait
-- [/store_unit_portrait]
---
function wesnoth.wml_actions.store_unit_portrait(cfg)
	local u = wesnoth.get_units(cfg)[1] or helper.wml_error("[store_unit_portrait]: Could not match any units")
	local varname = cfg.variable or "unit_portrait"

	local img = u.__cfg.profile

	if (not img) or img ~= "unit_image" then
		local mods = u.image_mods
		if mods then
			img = string.format("%s~%s~TC(%d,%s)", u.__cfg.image, mods, u.side, u.__cfg.flag_rgb)
		else
			img = string.format("%s~TC(%d,%s)", u.__cfg.image, u.side, u.__cfg.flag_rgb)
		end
	end

	wesnoth.set_variable(varname, img)
end

---
-- Sets the given variable to a boolean value depending
-- on whether the given conditional statements pass or not.
--
-- [set_conditional_variable]
--     name= (required string: variable name)
--     [condition]
--         ...
--     [/condition]
-- [/set_conditional_variable]
---
function wesnoth.wml_actions.set_conditional_variable(cfg)
	local varname = cfg.name
	local condition = helper.get_child(cfg, "condition")

	if varname == nil then
		helper.wml_error("[set_conditional_variable]: Required 'name' attribute missing")
	end

	if condition == nil then
		helper.wml_error("[set_conditional_variable]: Required '[condition]' tag missing")
	end

	wesnoth.set_variable(varname, wesnoth.eval_conditional(condition))
end

---
-- Fades out the currently playing music and replaces
-- it with silence afterwards.
--
-- NOTE: A possible timing issue in the sound code causes
-- Wesnoth to emit some short (< 100 ms) noise at the end
-- of the sequence when replacing the music playlist. This
-- also normally occurs when quitting a scenario that uses
-- silence.ogg to return to the titlescreen. It's advised
-- to have some ambient noise playing at the same time
-- [fade_out_music] is used. Furthermore, it's not possible
-- to determine at this time whether music is enabled in
-- the first place, so the fade out delay will always occur
-- regardless of the user's preferences.
--
-- [fade_out_music]
--     duration= (optional int, defaults to 1000 ms)
-- [/fade_out_music]
---
function wesnoth.wml_actions.fade_out_music(cfg)
	local duration = cfg.duration

	if duration == nil then
		duration = 1000
	end

	local function set_music_volume(percentage)
		wesnoth.fire("volume", { music = percentage })
	end

	local delay_granularity = 10

	duration = math.max(delay_granularity, duration)
	local rem = duration % delay_granularity

	if rem ~= 0 then
		duration = duration - rem
	end

	local steps = duration / delay_granularity
	--wesnoth.message(string.format("%d steps", steps))

	for k = 1, steps do
		local v = helper.round(100 - (100*k / steps))
		--wesnoth.message(string.format("step %d, volume %d", k, v))
		set_music_volume(v)
		wesnoth.delay(delay_granularity)
	end

	wesnoth.set_music({
		name = "silence.ogg",
		immediate = true,
		append = false
	})

	set_music_volume(100)
end

---
-- Checks whether the second unit ([filter_second]) is within the movement
-- range of the first unit ([filter]), and stores the truth value as a
-- boolean in the given variable (or in_range if not specified).
--
-- [check_unit_in_range]
--     [filter]
--         (primary unit SUF)
--     [/filter]
--     [filter_second]
--         (secondary unit SUF)
--     [/filter_second]
--     variable=(optional string, default to "in_range")
-- [/check_unit_in_range]
---

function wesnoth.wml_actions.check_unit_in_range(cfg)
	local primary_suf = helper.get_child(cfg, "filter") or
		helper.wml_error "[check_unit_in_range] missing required [filter] tag"
	local second_suf = helper.get_child(cfg, "filter_second") or
		helper.wml_error "[check_unit_in_range] missing required [filter_second] tag"
	local variable = cfg.variable

	if variable == nil then
		variable = "in_range"
	end

	local u1 = wesnoth.get_units(primary_suf)[1] or
		helper.wml_error "[check_unit_in_range] could not match primary unit"
	local u2 = wesnoth.get_units(second_suf)[1] or
		helper.wml_error "[check_unit_in_range] could not match secondary unit"

	if helper.distance_between(u1.x, u1.y, u2.x, u2.y) <= u1.max_moves then
		wesnoth.set_variable(variable, true)
	else
		wesnoth.set_variable(variable, false)
	end
end
