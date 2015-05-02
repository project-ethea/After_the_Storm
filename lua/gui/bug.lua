local T = helper.set_wml_tag_metatable {}

---
-- Displays an error message on a popup dialog.
--
-- This is intended to be used as an exit mechanism when the WML detects an
-- inconsistency (see the BUG and BUG_ON macros in base-debug.cfg
--
-- [bug]
--     message= <...>
--     may_ignore= boolean, defaults to yes
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

	local report = cfg.should_report
	local notice = cfg.message
	local log_notice = notice
	local may_ignore = cfg.may_ignore

	if log_notice == nil or log_notice == "" then
		log_notice = "inconsistency detected"
	end

	if report == nil then
		report = true
	end

	if may_ignore == nil then
		may_ignore = true
	end

	wput(W_ERR, "BUG: " .. log_notice)

	local alert_dialog = {
		maximum_width = 640,
		maximum_height = 400,
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
					horizontal_grow = true,
					T.grid {
						T.row {
							T.column {
								horizontal_alignment = "left",
								border = "all",
								border_size = 5,
								grow_factor = 1,
								T.button { id = "details" }
							},
							T.column {
								horizontal_alignment = "right",
								border = "all",
								border_size = 5,
								T.button { id = "ok", label = wgettext("Continue"), return_value = 1 }
							},
							T.column {
								horizontal_alignment = "right",
								border = "all",
								border_size = 5,
								T.button { id = "quit", label = wgettext("Quit"), return_value = 2 }
							}
						}
					}
				}
			}
		}
	}

	local function show_details()
		local dialog = {
			maximum_width = 640,
			maximum_height = 400,
			T.helptip { id="tooltip_large" },
			T.tooltip { id="tooltip_large" },
			T.grid {
				T.row {
					T.column {
						horizontal_alignment = "left",
						grow_factor = 1,
						border = "all",
						border_size = 5,
						T.label { definition = "title", id = "title", wrap = true }
					}
				},
				T.row {
					T.column {
						horizontal_alignment = "left",
						border = "all",
						border_size = 5,
						T.label { id = "message", wrap = true }
					}
				},
				T.row {
					T.column {
						vertical_alignment = "center",
						horizontal_grow = "true",
						border = "all",
						border_size = 5,
						T.scroll_label { id = "wml", definition = "description", vertical_scrollbar_mode = "always" }
					},
				},
				T.row {
					T.column {
						horizontal_alignment = "right",
						border = "all",
						border_size = 5,
						T.button { id = "ok", label = wgettext("Continue") }
					}
				}
			}
		}

		-- #textdomain wesnoth-After_the_Storm
		local _ = wesnoth.textdomain "wesnoth-After_the_Storm"
		local cap = _ "Details"
		local msg = _ "The following WML condition was unexpectedly reached:"

		wesnoth.show_dialog(dialog, function()
			wesnoth.set_dialog_value(cap, "title")
			wesnoth.set_dialog_value(msg, "message")
			wesnoth.set_dialog_value(wesnoth.debug(cond), "wml")
		end)
	end

	local function preshow()
		-- #textdomain wesnoth-After_the_Storm
		local _ = wesnoth.textdomain "wesnoth-After_the_Storm"
		local msg = _ "An inconsistency has been detected, and the scenario might not continue working as originally intended."

		if report then
			msg = msg .. "\n\n" .. _ "Please report this to the campaign maintainer!"
		end

		if notice ~= nil and notice ~= "" then
			msg = msg .. "\n\n" .. _ "Message:"
			msg = msg .. "\n\t" .. cfg.message
		end

		msg = msg .. "\n"

		local cap = _ "Error"
		local det = _ "Details"

		wesnoth.set_dialog_value(cap, "title")
		wesnoth.set_dialog_value(msg, "message")
		wesnoth.set_dialog_value(det, "details")

		if cond then
			wesnoth.set_dialog_callback(show_details, "details")
		else
			wesnoth.set_dialog_active(false, "details")
		end

		if not may_ignore then
			wesnoth.set_dialog_active(false, "ok")
		end
	end

	local dialog_result = wesnoth.show_dialog(alert_dialog, preshow, nil)

	if wesnoth.game_config.debug then
		wesnoth.wml_actions.inspect {}
	end

	if dialog_result == 2 or not may_ignore then
		wesnoth.fire("endlevel", {
			result = "defeat",
			linger_mode = false
		})
	end
end
