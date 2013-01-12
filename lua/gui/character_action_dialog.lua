local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- [character_action_dialog]
--     variable=choice
--     can_dismiss=true
--     [option]
--         message= ...
--     [/option]
--     [option]
--         message= ...
--     [/option]
--     ...
-- [/character_action_dialog]
---
function wesnoth.wml_actions.character_action_dialog(cfg)
	local var = cfg.variable or "choice"
	local can_dismiss = cfg.can_dismiss
	if can_dismiss == nil then can_dismiss = true end

	local _ = nil

	local list_definition = {
		T.row {
			T.column {
				vertical_grow = true,
				horizontal_grow = true,
				T.toggle_panel {
					definition = "default",
					return_value_id = "ok",
					T.grid {
						T.row {
							T.column {
								grow_factor = 1,
								horizontal_grow = true,
								border = "all",
								border_size = 5,
								T.label {
									id = "item",
									definition = "default",
									linked_group = "item"
								}
							}
						}
					}
				}
			}
		}
	} -- end list_definition

	local dialog_definition = {
		maximum_width = 800,
		maximum_height = 600,
		T.helptip { id = "tooltip_large" },
		T.tooltip { id = "tooltip_large" },
		T.linked_group { id = "item", fixed_width = true },
		T.grid {
			-- NOTE: This dialog lacks a title label row on purpose.
			T.row {
				grow_factor = 1,
				T.column {
					grow_factor = 1,
					horizontal_grow = true,
					vertical_grow = true,
					border = "all",
					border_size = 5,
					T.listbox {
						id = "listbox",
						definition = "default",
						T.list_definition(list_definition)
					}
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
							}
						}
					}
				}
			}
		}
	} -- end dialog_definition

	local function on_select()
		local list_pos = wesnoth.get_dialog_value("listbox")
		wesnoth.set_variable(var, list_pos - 1)
	end

	local function preshow()
		local tstring = ""

		-- #textdomain wesnoth
		_ = wesnoth.textdomain "wesnoth"
		tstring = _ "OK"

		wesnoth.set_dialog_value(tstring, "ok")

		local list_pos = 1

		for opt in helper.child_range(cfg, "option") do
			wesnoth.set_dialog_value(opt.message, "listbox", list_pos, "item")
			list_pos = list_pos + 1
		end

		if can_dismiss then
			-- #textdomain wesnoth-After_the_Storm
			_ = wesnoth.textdomain "wesnoth-After_the_Storm"
			tstring = _ "Continue."

			-- The mandatory "carry on" option.
			wesnoth.set_dialog_value(tstring, "listbox", list_pos, "item")
			wesnoth.set_dialog_value(list_pos, "listbox")
		else
			wesnoth.set_dialog_value(1, "listbox")
		end

		wesnoth.set_dialog_callback(on_select, "listbox")

		on_select()
	end

	--wesnoth.synchronize_choice(function()
		wesnoth.show_dialog(dialog_definition, preshow, nil) --end)

end
