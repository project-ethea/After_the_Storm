---
-- Handle saved games generated before the 'fairy' race was
-- renamed to 'faerie' in AtS 0.9.4, including file paths.
--
-- TODO: remove after 0.9.4 or 0.9.5.
---

local helper = wesnoth.require "lua/helper.lua"

function faerie_spelling_transition_handler()
	local function _log(text)
		wesnoth.fire("wml_message", { message = text, logger = "info" })
	end

	_log "BEGIN: faerie spelling transition handler"

	local fn_patn = '/fairies/'
	local fn_repl = '/faeries/'

	local function do_recursive_fixup(ucfg)
		if ucfg.image ~= nil
			and type(ucfg.image) == "string"
			and string.match(ucfg.image, fn_patn)
		then
			local newval = string.gsub(ucfg.image, fn_patn, fn_repl)
			_log(string.format("    IMAGE PATH: %s -> %s", ucfg.image, newval))
			ucfg.image = newval
		end

		for i, node in ipairs(helper.shallow_literal(ucfg)) do
			-- _log("TABLE: " .. node[1]) -- node tag
			do_recursive_fixup(node[2]) -- node contents
		end
	end

	local function fixup(ucfg)
		ucfg.race = "faerie"

		if ucfg.profile == 'images/units/fairies/fairy.png' then
			ucfg.profile = 'images/units/faeries/fire.png'
		else
			ucfg.profile = string.gsub(ucfg.profile, fn_patn, fn_repl)
		end

		do_recursive_fixup(ucfg)
	end

	---
	-- Fix units on the map and recall list.
	---

	local filter = { race = "fairy" } 

	for i, u in ipairs(wesnoth.get_units(filter)) do
		_log(string.format("  FIX: %s (%s) [gamemap]", u.id, tostring(u.name)))

		local ucfg_new = u.__cfg
		fixup(ucfg_new)
		wesnoth.put_unit(ucfg_new)
	end

	for i, u in ipairs(wesnoth.get_recall_units(filter)) do
		_log(string.format("  FIX: %s (%s) [recall]", u.id, tostring(u.name)))

		local ucfg_new = u.__cfg
		fixup(ucfg_new)
		wesnoth.put_recall_unit(ucfg_new)
	end

	---
	-- Fix stored units.
	---

	-- NO FUCK THIS
	--local fixup_containers = {}

	_log "END: faerie spelling transition handler"
end

-- Register a preload event handler to bootstrap ourselves.

wesnoth.fire("event", {
	name = "preload",
	{ "lua", { code = "faerie_spelling_transition_handler()" } }
})
