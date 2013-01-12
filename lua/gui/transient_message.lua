local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- Displays a transparent message box that's dimissed when clicked.
--
-- [transient_message]
--     caption=(tstring)
--     message=(tstring)
--     transparent=(boolean)
--     image=(image path)
--     sound=(string)
-- [/transient_message]
---
function wesnoth.wml_actions.transient_message(cfg)
	-- HACK: Don't set a border size for the image cell when
	--       there's no image to display; this way it doesn't
	--       result in some empty space to the left of the text.
	local image_margin = 0
	if cfg.image ~= nil then
		image_margin = 5
	end

	local dd = {
		maximum_width = 800,
		maximum_height = 600,
		click_dismiss = true,
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field

		T.grid {
			T.row {
				T.column {
					border = "all", border_size = image_margin,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					T.image { id = "image" }
				},
				T.column {
					T.grid {
						T.row {
							T.column {
								border = "all", border_size = 5,
								vertical_alignment = "top",
								horizontal_alignment = "left",
								T.label {
									id = "caption",
									definition = "title"
								}
							}
						},
						T.row {
							T.column {
								border = "all", border_size = 5,
								vertical_alignment = "top",
								horizontal_alignment = "left",
								T.label {
									id = "message",
									definition = "wml_message",
									wrap = true
								}
							}
						}
					}
				}
			}
		}
	}

	local transparent = cfg.transparent
	if transparent == nil then transparent = true end

	if transparent then
		dd.definition = "message"
	end

	local caption = cfg.caption
	if caption == nil then caption = "" end
	local message = cfg.message
	if message == nil then message = "" end

	local function preshow()
		wesnoth.set_dialog_value(caption, "caption")
		wesnoth.set_dialog_value(message, "message")

		if cfg.image then
			wesnoth.set_dialog_value(cfg.image, "image")
		end
	end

	local sound = cfg.sound
	if sound ~= nil then wesnoth.play_sound(sound) end

	wesnoth.show_dialog(dd, preshow, nil)
end
