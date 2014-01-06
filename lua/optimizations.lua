---
-- Lua versions of mainline WML macros to reduce the campaign's WML footprint
-- (memory and disk usage).
--
-- See macros/optimizations.cfg.
---

function wesnoth.wml_actions.quake(cfg)
	local function scroll(x, y)
		wesnoth.fire("scroll", { x = x, y = y })
	end

	local sound = cfg.sound

	if sound then
		wesnoth.play_sound(sound)
	end

	scroll(  5,   0)
	scroll(-10,   0)
	scroll(  5,   5)
	scroll(  0, -10)
	scroll(  0,   5)
end
