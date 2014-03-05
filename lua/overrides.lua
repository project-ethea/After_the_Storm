---
-- Overrides for mainline Lua WML actions.
--
-- Workarounds for mainline WML action implementation bugs (either in Lua or
-- C++ actions) also belong here.
---

---
-- Extend [remove_sound_source] to take a comma-separated list of sound
-- sources to remove.
---

local engine_rss = wesnoth.wml_actions.remove_sound_source

function wesnoth.wml_actions.remove_sound_source(cfg)
	local ids = cfg.id or helper.wml_error("[remove_sound_source]: No id list provided")
	for id in ids:gmatch("[^,]+") do
		engine_rss { id = id:match "^%s*(.-)%s*$" }
	end
end
