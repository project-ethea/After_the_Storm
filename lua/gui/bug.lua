local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- Displays an error message on a popup dialog.
--
-- This is intended to be used as an exit mechanism when the WML detects an
-- inconsistency (see the BUG and BUG_ON macros in base-debug.cfg
--
-- [bug]
--     message= <...>
--     # Optional conditional statement
--     [condition]
--         ...
--     [/condition]
-- [/bug]
---
function wesnoth.wml_actions.bug(cfg)
	local cond = helper.get_child(cfg, "condition")

	if cond and not wesnoth.eval_conditional(cond) then
		return
	end

	local notice = cfg.message
	local log_notice = notice

	if log_notice == nil or log_notice == "" then
		log_notice = "inconsistency detected"
	end

	wesnoth.fire("wml_message", {
		logger = "error",
		message = "[AtS] BUG: " .. log_notice
	})

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
					T.label { definition = "title", id = "title", wrap = true }
				}
			},
			T.row {
				T.column {
					vertical_alignment = "center",
					horizontal_alignment = "center",
					border = "all",
					border_size = 5,
					T.label { id = "message", wrap = true }
				}
			},
			T.row {
				T.column {
					horizontal_alignment = "right",
					T.grid {
						T.row {
							T.column {
								border = "all",
								border_size = 5,
								T.button { id = "ok", return_value = 1 }
							},
							T.column {
								border = "all",
								border_size = 5,
								T.button { id = "quit", return_value = 2 }
							}
						}
					}
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

		if notice ~= nil and notice ~= "" then
			msg = msg .. "\n\n" .. _ "Message:"
			msg = msg .. "\n\t" .. cfg.message
		end

		local cap =  _ "Error"

		-- #textdomain wesnoth
		_ = wesnoth.textdomain "wesnoth"
		local ok = _ "Continue"
		local quit = _ "Quit"

		wesnoth.set_dialog_value(cap, "title")
		wesnoth.set_dialog_value(msg, "message")
		wesnoth.set_dialog_value(ok , "ok")
		wesnoth.set_dialog_value(quit , "quit")
	end

	if wesnoth.show_dialog(alert_dialog, preshow, nil) == 2 then
		wesnoth.fire("endlevel", {
			result = "defeat",
			linger_mode = false
		})
	end
end
