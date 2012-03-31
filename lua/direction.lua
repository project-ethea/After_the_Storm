---
-- Half-assed attempt at translating the algorithm in map_location::get_relative_dir()
-- to Lua. It doesn't work correctly in at least one case, when the destination hex is
-- adjacent to the origin on the south. It also yields north and south for distant hexes
-- that should really be northeast/northwest or southeast/southwest (maybe? haven't
-- checked whether the original algorithm does that too).
--
-- Kept in here for now in case I decide to revisit it later.
---

local helper = wesnoth.require "lua/helper.lua"

local function loc_neg(a)
	return { x = -a.x, y = -a.y }
end

local function loc_sum(a, b)
	local parity = (a.x % 2 == 0)
	local s = { x = a.x + b.x, y = a.y + b.y }

	if b.x > 0 and b.x % 2 and parity then
		s.y = s.y + 1
	end
	if b.x < 0 and b.x % 2 and not parity then
		s.y = s.y - 1
	end

	return s
end

local function loc_diff(a, b)
	return loc_sum(a, loc_neg(b))
end

local function loc_is_zero(a)
	return (a.x == 0 and a.y == 0)
end

local function loc_relative_direction(a, b)
	local diff = loc_diff(a, b)

	if(loc_is_zero(diff)) then return nil end

	if diff.y < 0 and diff.x >= 0 and math.abs(diff.x) >= math.abs(diff.y) then return "ne" end
	if diff.y < 0 and diff.x < 0  and math.abs(diff.x) >= math.abs(diff.y) then return "nw" end
	if diff.y < 0 and math.abs(diff.x) < math.abs(diff.y) then return "n" end

	if diff.y >= 0 and diff.x >= 0 and math.abs(diff.x) >= math.abs(diff.y) then return "se" end
	if diff.y >= 0 and diff.x < 0  and math.abs(diff.x) >= math.abs(diff.y) then return "sw" end
	if diff.y >= 0 and math.abs(diff.x) < math.abs(diff.y) then return "s" end

	return nil
end

---
-- Gets the relative direction of a source hex to a target hex.
--
-- [store_direction]
--     from_x,from_y= ...
--     to_x,to_y= ...
--     variable="direction"
-- [/store_direction]
---
function wesnoth.wml_actions.store_direction(cfg)
	local a = { x = cfg.from_x, y = cfg.from_y }
	local b = { x = cfg.to_x  , y = cfg.to_y   }

	if not a.x or not a.y or not b.x or not b.y then
		helper.wml_error "[store_direction] missing coordinate!"
	end

	local variable = cfg.variable or "direction"

	local facing = loc_relative_direction(b, a) or "sw"

	wesnoth.set_variable(variable, facing)
end
