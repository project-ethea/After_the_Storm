local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- Displays an image on a popup dialog.
--
-- [show_image]
--     image= ...
-- [/show_image]
---
function wesnoth.wml_actions.show_image(cfg)
	local function do_error(msg)
		helper.wml_error("[show_image]: " .. msg)
	end

	local img = cfg.image or do_error("required 'image' attribute is missing")

	local dd = {
		-- NOTE: Can't use transparency until mainline #19165 is fixed!
		-- definition = "message",
		maximum_width = 800,
		maximum_height = 480,
		click_dismiss = true,
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field
		T.grid {
			T.row {
				T.column {
					border = "all", border_size = 5,
					T.image {
						id = "image", definition = "default"
					}
				}
			}
		}
	}

	local function preshow()
		wesnoth.set_dialog_value(img, "image")
	end

	wesnoth.show_dialog(dd, preshow, nil)
end
