local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- Displays a simple transient message at the top, without any
-- captions or images.
--
-- [top_message]
--     message=(tstring)
-- [/top_message]
---
function wesnoth.wml_actions.top_message(cfg)
	local dd = {
		definition = "message",

		vertical_placement = "top",
		horizontal_placement = "center",

		-- TODO: we can't use manual placement yet because then the width and height
		--       become static and the game fails if the text doesn't fit later.
		--
		-- automatic_placement = false,
		-- x = "(screen_width / 2)",
		-- the menu bar height (26 px) plus the standard margin size
		-- y = "(26 + 5)",
		-- width = 200,
		-- height = 100,

		maximum_width = 800,
		maximum_height = 600,

		click_dismiss = true,

		T.helptip { id="tooltip_large" },
		T.tooltip { id="tooltip_large" },

		T.grid {
			T.row {
				T.column {
					border = "all", border_size = 20,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					T.label { id = "message", definition = "default" }
				}
			}
		}
	}

	local message = cfg.message
	if message == nil then message = "" end

	local function preshow()
		wesnoth.set_dialog_value(message, "message")
	end

	wesnoth.show_dialog(dd, preshow, nil)
end
