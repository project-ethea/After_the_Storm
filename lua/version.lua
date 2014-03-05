---
-- Checks for Wesnoth version compatibility
---

local function do_bug(msg, may_ignore)
	wesnoth.wml_actions.bug { message = msg, should_report = false, may_ignore = may_ignore }
end


local ver = wesnoth.game_config.version
local v = wesnoth.compare_versions

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

if v(ver, '<', '1.11.11') then
	do_bug( _ "After the Storm requires Wesnoth 1.11.11 or later. Versions 1.11.8 and 1.11.9 (but not 1.11.10) may also work; however, no support can be provided by the campaign maintainer in the forums.", v(ver, '>=', '1.11.8') and v(ver, '<=', '1.11.9'))
end
