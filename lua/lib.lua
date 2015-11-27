---
-- Lua utilities library
---

---
-- TODO: use utils.split() on 1.13.x instead
---
function split(s)
	return tostring(s):gmatch("[^%s,][^,]*")
end

---
-- Log levels for wput and wprintf.
---

W_ERR  = 1 -- Error.
W_WARN = 2 -- Warning (default maximum log level).
W_INFO = 3 -- Info.
W_DBG  = 4 -- Debug.

local loglvl_map = { "error", "warning", "info", "debug" }

---
-- Prints a text line using the engine log facilities.
--
-- lvl: One of W_ERR, W_WARN, W_INFO, or W_DBG.
-- msg: Line contents.
---
function wput(lvl, msg)
	wesnoth.wml_actions.wml_message({
		logger = loglvl_map[math.max(1, math.min(lvl, #loglvl_map))],
		message = "[AtS] " .. msg
	})
end

---
-- Prints a formatted (printf-style) line using the engine log facilities.
--
-- lvl: One of W_ERR, W_WARN, W_INFO, or W_DBG.
-- fmt: Line format specification.
-- ...: Parameters for line formatting.
---
function wprintf(lvl, fmt, ...)
	wput(lvl, string.format(fmt, ...))
end

---
-- Returns a textdomain-specific string translated to the current locale
--
-- Note that this is only intended to be used with mainline textdomains. For
-- add-on textdomains the _ hack including comments with fake WML is still
-- needed so that wmlxgettext can catch and add the new strings.
---
function wgettext(str, domain)
	if domain == nil then
		domain = "wesnoth"
	end

	return wesnoth.textdomain(domain)(str)
end

---
-- Shuffles a table.
--
-- This is helper.shuffle from 1.13.1+dev, backported to 1.12.x sans the RNG
-- function parameter.
---
function safe_shuffle(t)
	local function random_func(a, b)
		return helper.rand(("%d..%d"):format(a, b))
	end
	-- since tables are passed by reference, this is an in-place shuffle
	-- it uses the Fisher-Yates algorithm, also known as Knuth shuffle
	assert( type( t ) == "table", string.format( "helper.shuffle expects a table as parameter, got %s instead", type( t ) ) )
	local length = #t
	for index = length, 2, -1 do
		local random = random_func( 1, index )
		t[index], t[random] = t[random], t[index]
	end
end

wprintf(W_INFO, "Version %s initializing", PROJECT_Y_AFTER_THE_STORM_VERSION)
