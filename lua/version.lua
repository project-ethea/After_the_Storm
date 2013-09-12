---
-- Checks for Wesnoth version compatibility
---

function do_bug(msg)
	wesnoth.fire("bug", { message = msg, should_report = false })
end

function wesnoth_version_compat_check()

	local ver = wesnoth.game_config.version
	local v = wesnoth.compare_versions

	-- #textdomain wesnoth-After_the_Storm
	local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

	if v(ver, '<', '1.10.0') then
		if v(ver, '<', '1.9.10') then
			do_bug( _ "After the Storm requires Wesnoth 1.10.0 or later.")
		else
			do_bug( _ "After the Storm requires Wesnoth 1.10.0 or later. Versions 1.9.10 through 1.9.14 may work to some extent, but no support can be provided by the campaign maintainer in the forums.")
		end
	end

	if v(ver, '>=', '1.11.0') and v(ver, '<', '1.11.2') then
		do_bug( _ "After the Storm III is incompatible with Wesnoth versions 1.11.0 and 1.11.1 due to a team management bug. Please upgrade to the latest development version.")
	end

end

wesnoth.fire("event", {
	name = "preload",
	{ "lua", { code = "wesnoth_version_compat_check()" } }
})
