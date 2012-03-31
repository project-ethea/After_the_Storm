local helper = wesnoth.require "lua/helper.lua"

-- metatable for GUI tags
local T = helper.set_wml_tag_metatable {}

---
-- Displays an error message in a popup dialog.
--
-- This is intended to be used as an exit mechanism when the WML detects an
-- inconsistency (see the BUG and BUG_ON macros in base-debug.cfg
--
-- [bug]
--     message= <...>
-- [/bug]
--
-- Most of the code has been shamelessly stolen from Wesnoth Lua Pack.
---
function wesnoth.wml_actions.bug( cfg )
	local alert_dialog = {
			maximum_width = 800,
			maximum_height = 600,
			T.helptip { id="tooltip_large" }, -- mandatory field
			T.tooltip { id="tooltip_large" }, -- mandatory field
			T.grid { -- Title, will be the object name
				T.row {
					T.column {
						horizontal_alignment = "left",
						grow_factor = 1, -- this one makes the title bigger and golden
						border = "all",
						border_size = 5,
						T.label { definition = "title", id = "title" }
					}
				},
				T.row {
					T.column {
						vertical_alignment = "center",
						horizontal_alignment = "center",
						border = "all",
						border_size = 5,
						T.label { id = "message" }
					}
				},
				T.row {
					T.column {
						horizontal_alignment = "center",
						border = "all",
						border_size = 5,
						T.button { id = "ok", return_value = 1 }
					}
				}
			}
		}

	local function preshow()
		local _ = nil

		-- #textdomain wesnoth-After_the_Storm
		_ = wesnoth.textdomain "wesnoth-After_the_Storm"
		local msg = _ "An inconsistency has been detected, and the scenario might not continue working as originally intended."
		msg = msg .. "\n" .. _ "Please report this to the campaign maintainer!"
		msg = msg .. "\n\n" .. _ "Message:"
		msg = msg .. "\n\t" .. cfg.message
		local cap =  _ "Error"

		-- #textdomain wesnoth
		_ = wesnoth.textdomain "wesnoth"
		local ok = _ "OK"

		wesnoth.set_dialog_value(cap, "title")
		wesnoth.set_dialog_value(msg, "message")
		wesnoth.set_dialog_value(ok , "ok")
	end

	local function postshow()
		-- here get all widget values
	end
	wesnoth.show_dialog( alert_dialog, preshow, postshow )
	-- no syncronization, as we aren't interested in returned values
end
