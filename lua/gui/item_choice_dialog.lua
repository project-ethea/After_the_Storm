local T = wml.tag

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
	if not wml.get_child(cfg, "option") then
		wml.error("[item_choice_dialog]: missing mandatory [option] children")
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

	local ok_label = wgettext("Close")

	if not can_dismiss then
		ok_label = wgettext("OK")
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
										id = "page",
										T.row {
											T.column {
												border = "all", border_size = 5,
												horizontal_alignment = "left",
												vertical_grow = true,
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

	local function preshow(self)
		if cfg.title then
			self.title.label = cfg.title
		end

		if cfg.text then
			self.text.label = cfg.text
		end

		for entry in wml.child_range(cfg, "option") do
			local image = entry.image or ""
			local title = entry.title or "-"
			local text = entry.text or ""

			local row = self.option_list:add_item()
			row.option_icon.label = image
			row.option_title.label = title

			local page = self.current_option_pager:add_item_of_type("page")
			page.current_option_text.marked_up_text = ("<b>%s:</b>\n\n%s"):format(title, text)
		end

		page_count = self.current_option_pager.item_count

		local function on_select()
			local i = self.option_list.selected_index
			if i > page_count then
				wput(W_ERR, "invalid option_list row number")
				return
			end

			self.current_option_pager.selected_index = i
		end

		self.option_list.on_modified = on_select
		-- Select the first entry by default.
		self.option_list.selected_index = 1
		self.option_list:focus()
		on_select()
	end

	local res = wesnoth.sync.evaluate_single(function()
		local choice = -1
		local retval = gui.show_dialog(
			dialog_definition, preshow,
			function(self) choice = (self.option_list.selected_index - 1) end
		)
		return { status = retval, value = choice }
	end)

	if variable ~= nil then
		if res.status == -2 then
			wml.variables[variable] = -1
		else
			wml.variables[variable] = res.value
		end
	end
end
