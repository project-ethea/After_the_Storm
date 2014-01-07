---
-- Lua functions dealing with hex board geometry tasks, including calculating
-- the relative direction between two points.
--
-- Thanks to mattsc for the functions hex_to_cartesian, hex_angle,
-- hex_direction_index, and the basic idea behind hex_facing.
---

---
-- Converts coordinates from hex geometry to cartesian coordinates,
-- meaning that y coordinates are offset by 0.5 every other hex.
--
-- Example: (1,1) stays (1,1) and (3,1) remains (3,1), but (2,1) -> (2,1.5),
--          etc.
---
local function hex_to_cartesian(x, y)
	return x, y + ((x + 1) % 2) / 2.0
end

---
-- Returns the angle between hexes a and b in radians [-pi, pi]. 0 is towards
-- the east. The input must be of the form { x = x, y = y }, which means it is
-- possible to pass a unit table.
---
local function hex_angle(a, b)
	local x1, y1 = hex_to_cartesian(a.x, a.y)
	local x2, y2 = hex_to_cartesian(b.x, b.y)

	return math.atan2(y2 - y1, x2 - x1)
end

---
-- Returns an integer index for the direction from a to b with the full circle
-- divided into n slices. 1 is always to the east, with indices increasing
-- clockwise. The input must be of the form { x = x, y = y }, which means it
-- is possible to pass a unit table.
--
-- By default, the eastern direction is the northern border of the first slice.
-- If the center_on_east parameter is set to true, east will be the center
-- direction of the first slice.
---
local function hex_direction_index(a, b, n, center_on_east)
	local d_east = 0
	if center_on_east then d_east = 0.5 end

	return 1 + math.floor((hex_angle(a, b) / math.pi * n/2 + d_east) % n)
end

function hex_facing(a, b)
	-- Optimization for identical A and B locations.
	if a.x == b.x and a.y == b.y then
		return "se"
	end

	-- We need to handle north and south directions specially since otherwise
	-- they are handled as circular sectors rather than axes.
	if a.x == b.x then
		if a.y > b.y then
			return "n"
		else
			return "s"
		end
	end

	-- A and B aren't parallel to/on the Y axis, go with sectors for the
	-- ordinal directions.
	local dirs = { "se", "sw", "nw", "ne" }
	return dirs[hex_direction_index(a, b, #dirs)]
end
