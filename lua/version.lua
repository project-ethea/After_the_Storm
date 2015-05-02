---
-- Checks for Wesnoth version compatibility
---

local function do_bug(msg, may_ignore)
	wesnoth.wml_actions.bug { message = msg, should_report = false, may_ignore = may_ignore }
end

local function have_addon(id)
	return wesnoth.have_file("~add-ons/" .. id)
end

local ver = wesnoth.game_config.version
local v = wesnoth.compare_versions

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

if v(ver, '<', '1.11.11') then
	do_bug( _ "After the Storm requires Wesnoth 1.11.11 or later.", false)
end

if v(ver, '>=', '1.13.0') then
	do_bug( _ "After the Storm has not been tested with Wesnoth 1.13.x and there may be broken functionality. Please use version 1.12.0 or later.", false)
end

---
-- The following add-ons are known to case balancing issues with this campaign
-- or break boss fights and scripted cutscenes.

local bl_addons = {
	[ "Damage_Distribution_Mod" ]				= "Randomized Damage Mod",
	[ "Move_Units_Between_Campaigns" ]			= "Move Units Between Campaigns",
	[ "No_Randomness_Mod" ]						= "No Randomness Mod",
}

local bl_found = {}

for relpath, title in pairs(bl_addons) do
	local fpath = "~add-ons/" .. relpath
	if wesnoth.have_file(fpath) then
		wprintf(W_ERR, "Incompatible add-on or add-on file found: %s (%s)", fpath, title)
		table.insert(bl_found, title)
	end
end

if #bl_found ~= 0 then
	local msg, cap

	if #bl_found == 1 then
		cap = _ "Incompatible Add-on"
		msg = _ "The following add-on is incompatible with this campaign and must be removed before continuing:"
	else
		cap = _ "Incompatible Add-ons"
		msg = _ "The following add-ons are incompatible with this campaign and must be removed before continuing:"
	end

	msg = msg .. "\n\n"

	for i, title in ipairs(bl_found) do
		-- U+2022 BULLET
		msg = msg .. "    • " .. title .. "\n"
	end

	wesnoth.wml_actions.transient_message({
		caption = cap,
		message = msg,
		transparent = false
	})

	do_bug(nil, false)
end
