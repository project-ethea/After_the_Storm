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

W_ERR  = 1
W_WARN = 2
W_INFO = 3
W_DBG  = 4

local loglvl_map = { "error", "warning", "info", "debug" }

function wput(lvl, msg)
	wesnoth.wml_actions.wml_message({
		logger = loglvl_map[math.max(1, math.min(lvl, #loglvl_map))],
		message = "[AtS] " .. msg
	})
end

function wprintf(lvl, fmt, ...)
	wput(lvl, string.format(fmt, ...))
end

function wgettext(str, domain)
	if domain == nil then
		domain = "wesnoth"
	end

	return wesnoth.textdomain(domain)(str)
end

wprintf(W_INFO, "Version %s initializing", PROJECT_Y_AFTER_THE_STORM_VERSION)
