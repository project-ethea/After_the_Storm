---
-- Lua utilities library
---

function safe_random(arg)
	wesnoth.fire("set_variable", {
		name = "temp_ats_lua_random",
		rand = arg,
	})

	local r = wesnoth.get_variable("temp_ats_lua_random")
	wesnoth.set_variable("temp_ats_lua_random")

	return r
end
