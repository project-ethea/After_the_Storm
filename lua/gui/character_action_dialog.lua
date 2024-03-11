local T = wml.tag

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

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
								T.button {
									id = "ok",
									definition = "right_arrow_ornate",
									return_value = 1,
								}
							}
						}
					}
				}
			}
		}
	} -- end dialog_definition

	local res = wesnoth.sync.evaluate_single(function()
		local choice = 0

		local function preshow(self)
			local list_pos = 1

			for opt in wml.child_range(cfg, "option") do
				self.listbox:add_item().item.label = opt.message
			end

			if can_dismiss then
				-- The mandatory "carry on" option.
				self.listbox:add_item().item.label = _ "Continue."
				self.listbox.selected_index = self.listbox.item_count
			else
				self.listbox.selected_index = 1
			end

			local function on_select()
				choice = self.listbox.selected_index - 1
			end

			self.listbox.on_modified = on_select
			self.listbox:focus()
			on_select()
		end

		gui.show_dialog(dialog_definition, preshow, nil)

		return { value = choice }
	end)

	wml.variables[var] = res.value
end
