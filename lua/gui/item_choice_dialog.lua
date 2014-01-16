local T = helper.set_wml_tag_metatable {}

---
-- [item_choice_dialog]
--     title=(string) (optional)
--     text=(string) (optional)
--
--     can_dismiss=(boolean) (optional, defaults to true)
--     variable=(string) (optional, defaults to "choice" and only makes sense
--                       when can_dismiss is false)
--     [option]
--         image=(image path) (optional)
--         title=(string)
--         text=(string)
--     [/option]
-- [/item_choice_dialog]
---
function wesnoth.wml_actions.item_choice_dialog(cfg)
	-- Some early sanity checking.
	if not helper.get_child(cfg, "option") then
		helper.wml_error("[item_choice_dialog]: missing mandatory [option] children")
	end

	local variable = nil

	local can_dismiss = cfg.can_dismiss

	if can_dismiss == nil then
		can_dismiss = true
	elseif not can_dismiss then
		variable = cfg.variable or "choice"
	end

	local list_definition = {
		T.row {
			T.column {
				vertical_grow = true,
				horizontal_grow = true,
				T.toggle_panel {
					definition = "default",
					T.grid {
						T.row {
							T.column {
								grow_factor = 1,
								horizontal_grow = true,
								border = "all",
								border_size = 5,
								T.image {
									id = "option_icon",
									linked_group = "option_icon",
								}
							},
							T.column {
								grow_factor = 1,
								horizontal_grow = true,
								border = "all",
								border_size = 5,
								T.label {
									id = "option_title",
									linked_group = "option_title",
								}
							}
						}
					}
				}
			}
		}
	} -- end list_definition

	-- #textdomain wesnoth
	_ = wesnoth.textdomain "wesnoth"

	local ok_label = _ "Close"

	if not can_dismiss then
		ok_label = _ "OK"
	end

	local control_buttons_row = {
		T.column {
			border = "all", border_size = 5,
			T.button { id = "ok", label = ok_label }
		}
	}

	if not can_dismiss then
		control_buttons_row[2] = T.column {
			border = "all", border_size = 5,
			T.button { id = "cancel", label = _ "Cancel" }
		}
	end

	local dialog_definition = {
		click_dismiss = false,

		maximum_width = 640,
		maximum_height = 400,

		T.helptip { id = "tooltip_large" },
		T.tooltip { id = "tooltip_large" },

		T.linked_group { id = "option_icon", fixed_width = true },
		T.linked_group { id = "option_title", fixed_width = true },

		T.grid {
			T.row {
				grow_factor = 0,
				T.column {
					border = "all", border_size = 5,
					horizontal_alignment = "left",
					T.label {
						id = "title",
						definition = "title",
						wrap = true,
					}
				}
			},
			T.row {
				grow_factor = 0,
				T.column {
					border = "all", border_size = 5,
					horizontal_alignment = "left",
					T.label {
						id = "text",
						wrap = true,
					}
				}
			},
			T.row {
				grow_factor = 1,
				T.column {
					horizontal_alignment = "left",
					vertical_alignment = "top",
					T.grid {
						T.row {
							T.column {
								grow_factor = 1,
								border = "all", border_size = 5,
								horizontal_alignment = "left",
								vertical_alignment = "top",
								T.listbox {
									id = "option_list",
									definition = "default",
									T.list_definition(list_definition),
								}
							},
							T.column {
								grow_factor = 2,
								horizontal_alignment = "left",
								vertical_alignment = "top",
								T.multi_page {
									id = "current_option_pager",
									T.page_definition {
										T.row {
											T.column {
												border = "all", border_size = 5,
												horizontal_alignment = "left",
												vertical_alignment = "top",
												T.scroll_label {
													id = "current_option_text",
												}
											}
										}
									}
								}
							}
						}
					}
				}
			},
			T.row {
				grow_factor = 0,
				T.column {
					horizontal_alignment = "right",
					T.grid {
						T.row(control_buttons_row)
					}
				}
			}
		}
	} -- end dialog_definition

	local page_count = 0

	local function on_select()
		local i = wesnoth.get_dialog_value("option_list")

		if(i > page_count) then
			wesnoth.fire("wml_message", {
				logger = "error",
				message = "[AtS] BUG: invalid option_list row number"
			})

			return
		end

		wesnoth.set_dialog_value(i, "current_option_pager")
	end

	local function preshow()
		if cfg.title then
			wesnoth.set_dialog_value(cfg.title, "title")
		end

		if cfg.text then
			wesnoth.set_dialog_value(cfg.text, "text")
		end

		local i = 1

		for entry in helper.child_range(cfg, "option") do
			local image = entry.image
			if image == nil then image = "" end
			local title = entry.title
			if title == nil then title = "-" end
			local text = entry.text
			if text == nil then text = "" end

			wesnoth.set_dialog_value(image, "option_list", i, "option_icon")
			wesnoth.set_dialog_value(title, "option_list", i, "option_title")

			if wesnoth.compare_versions(wesnoth.game_config.version, ">", "1.11.8") then
				wesnoth.set_dialog_value("", "current_option_pager", i, "current_option_text")
				wesnoth.set_dialog_markup(true, "current_option_pager", i, "current_option_text")
				title = "<b>" .. title .. "</b>"
			end

			wesnoth.set_dialog_value(title .. ":\n\n" .. text, "current_option_pager", i, "current_option_text")

			i = i + 1
		end

		page_count = i

		wesnoth.set_dialog_callback(on_select, "option_list")

		-- Select the first entry by default.
		wesnoth.set_dialog_value(1, "option_list")
		on_select()
	end

	local res = wesnoth.synchronize_choice(function()
		local choice = -1
		local retval = wesnoth.show_dialog(
			dialog_definition, preshow,
			function() choice = (wesnoth.get_dialog_value("option_list") - 1) end
		)
		return { status = retval, value = choice }
	end)

	if variable ~= nil then
		if res.status == -2 then
			wesnoth.set_variable(variable, -1)
		else
			wesnoth.set_variable(variable, res.value)
		end
	end
end
