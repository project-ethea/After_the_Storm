local helper = wesnoth.require "lua/helper.lua"
local T = helper.set_wml_tag_metatable {}

---
-- [combo_info_dialog]
--     variable=(string) (optional, defaults to "combo_attacks" and specifies
--                        the WML container with information about attack combos)
-- [/combo_info_dialog]
---

function wesnoth.wml_actions.combo_info_dialog(cfg)

	local variable = cfg.variable

	if variable == nil then
		variable = "combo_attacks"
	end

	local function sigil_image_path(column, row)
		return string.format("icons/original-ten-sigils.png~CROP(%d, %d, 60, 60)", 60*column, 60*row)
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
								T.label {
									id = "combo_name",
									linked_group = "combo_name",
								}
							}
						},
						T.row {
							T.column {
								T.grid {
									T.row {
										T.column {
											grow_factor = 1,
											horizontal_grow = true,
											border = "all",
											border_size = 5,
											T.image {
												id = "side_a_icon",
												linked_group = "side_a_icon",
											}
										},
										T.column {
											grow_factor = 1,
											horizontal_grow = true,
											border = "all",
											border_size = 5,
											T.image {
												id = "symmetry_icon",
												linked_group = "symmetry_icon",
											}
										},
										T.column {
											grow_factor = 1,
											horizontal_grow = true,
											border = "all",
											border_size = 5,
											T.image {
												id = "side_b_icon",
												linked_group = "side_b_icon",
											}
										}
									}
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
	local close_label = _ "Close"

	-- #textdomain wesnoth-After_the_Storm
	_ = wesnoth.textdomain "wesnoth-After_the_Storm"
	local title_label = _ "Attack Combinations"

	local dialog_definition = {
		click_dismiss = false,

		maximum_width = 640,
		maximum_height = 400,

		T.helptip { id = "tooltip_large" },
		T.tooltip { id = "tooltip_large" },

		T.linked_group { id = "side_a_icon", fixed_width = true },
		T.linked_group { id = "symmetry_icon", fixed_width = true },
		T.linked_group { id = "side_b_icon", fixed_width = true },
		T.linked_group { id = "combo_name", fixed_width = true },

		T.grid {
			T.row {
				grow_factor = 0,
				T.column {
					border = "all", border_size = 5,
					horizontal_alignment = "left",
					T.label {
						id = "title",
						definition = "title",
						label = title_label,
						wrap = true
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
							--
							-- BIG FAT NOTE:
							--
							-- These columns are reversed on purpose. Normally, the listbox
							-- should be on the left and the multi_page parent grid on the
							-- right. However, this causes Wesnoth to crash due to running
							-- out of space for the listbox because the multi_page
							-- scroll_label children *somehow* take precedence when updating
							-- the widgets' geometry as the multi_page data is filled in by
							-- the preshow() callback.
							--
							-- This issue is averted by having the listbox on the rightmost
							-- column, so it takes precedence over the multi_page children
							-- whenever geometry changes. This is good, because the scroll_label
							-- widgets can then spawn their own scrollbars as needed.
							--
							-- Perhaps someone else may be able to provide a proper solution
							-- to this problem in the future.
							--
							T.column {
								vertical_grow = true,
								T.grid {
									T.row {
										grow_factor = 1,
										T.column {
											grow_factor = 2,
											horizontal_alignment = "left",
											vertical_alignment = "top",
											T.multi_page {
												id = "current_combo_pager",
												T.page_definition {
													T.row {
														T.column {
															border = "all", border_size = 5,
															horizontal_alignment = "left",
															vertical_alignment = "top",
															T.scroll_label {
																id = "current_combo_text",
															}
														}
													}
												}
											}
										}
									},
									T.row {
										grow_factor = 1,
										T.column {
											border = "all", border_size = 5,
											horizontal_grow = true,
											vertical_alignment = "bottom",
											T.grid {
												T.row {
													T.column {
														horizontal_alignment = "left",
														T.image { label = sigil_image_path(0, 1) }
													},
													T.column {
														horizontal_alignment = "right",
														T.image { label = sigil_image_path(3, 0) }
													}
												}
											}
										}
									}
								}
							},
							T.column {
								grow_factor = 1,
								border = "all", border_size = 5,
								horizontal_alignment = "left",
								vertical_alignment = "top",
								T.listbox {
									id = "combo_list",
									definition = "default",
									T.list_definition(list_definition),
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
						T.row {
							T.column {
								border = "all", border_size = 5,
								T.button { id = "ok", label = close_label }
							}
						}
					}
				}
			}
		}
	} -- end dialog_definition

	local page_count = 0

	local function do_error(text)
		wesnoth.fire("wml_message", { logger = "error", message = "[AtS] BUG: [combo_info_dialog] " .. text })
	end

	local function on_select()
		local i = wesnoth.get_dialog_value("combo_list")

		if(i > page_count) then
			do_error("invalid combo_list row number")
			return
		end

		wesnoth.set_dialog_value(i, "current_combo_pager")
	end

	local function bullet_list_item(text)
		-- U+2022 BULLET
		return "  • " .. text .. "\n"
	end

	local function preshow()
		local info_ary = helper.get_variable_array(variable)
		if info_ary == nil then
			do_error(string.format("could not read data from container '%s'", variable))
			return
		end

		for i, info_cfg in ipairs(info_ary) do

			local label = info_cfg.name
			local symmetric = info_cfg.symmetric

			--
			-- Obtain the WML nodes we need and their contents.
			--

			local effect_data = helper.get_child(info_cfg, "effect")
			if effect_data == nil then
				do_error(string.format("container '%s[%d]' has no 'effect' child node", variable, i - 1))
				return
			end

			local ui_data = helper.get_child(info_cfg, "ui")
			if ui_data == nil then
				do_error(string.format("container '%s[%d]' has no 'ui' child node", variable, i - 1))
				return
			end

			-- if ui_data.encountered ~= true then
			--	TODO?
			-- end

			local ui_side_a_data = helper.get_child(ui_data, "side_a")
			if ui_side_a_data == nil then
				do_error(string.format("container '%s[%d].ui' has no 'side_a' child node", variable, i - 1))
				return
			end

			local ui_side_b_data = helper.get_child(ui_data, "side_b")
			if ui_side_b_data == nil then
				do_error(string.format("container '%s[%d].ui' has no 'side_b' child node", variable, i - 1))
				return
			end

			--
			-- Parse [effect].
			--

			local effect_desc = string.format("%s:\n%s + %s\n\n",
				tostring(info_cfg.name),
				tostring(ui_side_a_data.attack_name),
				tostring(ui_side_b_data.attack_name))

			effect_desc = effect_desc .. _ "Effects:" .. "\n"

			if effect_data.apply_to == "damage" then
				--
				-- When the effect applies to "damage", the event handler
				-- for the attack combos mechanism turns it into a temporary
				-- [damage] weapon special.
				--
				-- The options we should handle here are 'value', 'add', 'sub',
				-- 'multiply', and 'divide'.
				--

				local fmt = ''

				if effect_data.value ~= nil then
					fmt = tostring( _ "attack damage base value set to %d")
					effect_desc = effect_desc .. bullet_list_item(string.format(fmt, effect_data.value))
				end

				if effect_data.add ~= nil then
					fmt = tostring( _ "+%d bonus to attack damage")
					effect_desc = effect_desc .. bullet_list_item(string.format(fmt, effect_data.add))
				end

				if effect_data.sub ~= nil then
					fmt = tostring( _ "−%d penalty to attack damage")
					effect_desc = effect_desc .. bullet_list_item(string.format(fmt, effect_data.sub))
				end

				if effect_data.multiply ~= nil then
					fmt = tostring( _ "×%d multiplier bonus to attack damage")
					effect_desc = effect_desc .. bullet_list_item(string.format(fmt, effect_data.multiply))
				end

				if effect_data.divide ~= nil then
					fmt = tostring( _ "÷%d divider penalty to attack damage")
					effect_desc = effect_desc .. bullet_list_item(string.format(fmt, effect_data.divide))
				end
			elseif effect_data.apply_to == nil then
				do_error(string.format("%s[%d].effect.apply_to attribute missing", variable, i - 1))
				return
			else
				do_error(string.format("%s[%d].effect.apply_to=\"%s\", which is not implemented yet", variable, i - 1, effect_data.apply_to))
				return
			end

			local symmetry_icon = "misc/gui-combo-arrows.png~CROP(0, 0, 60, 60)"
			if symmetric then
				symmetry_icon = "misc/gui-combo-arrows.png~CROP(60, 0, 60, 60)"

				effect_desc = effect_desc .. "\n"
				effect_desc = effect_desc .. _ "This combination is symmetric, and the attacks involved may be used in any order."
			end

			wesnoth.set_dialog_value(ui_side_a_data.attack_icon, "combo_list", i, "side_a_icon")
			wesnoth.set_dialog_value(symmetry_icon,              "combo_list", i, "symmetry_icon")
			wesnoth.set_dialog_value(ui_side_b_data.attack_icon, "combo_list", i, "side_b_icon")
			wesnoth.set_dialog_value(info_cfg.name,              "combo_list", i, "combo_name")

			wesnoth.set_dialog_value(effect_desc, "current_combo_pager", i, "current_combo_text")

			page_count = i
		end

		wesnoth.set_dialog_callback(on_select, "combo_list")

		-- Select the first entry by default.
		wesnoth.set_dialog_value(1, "combo_list")
		on_select()
	end

	-- This dialog is merely informative, so we don't
	-- need to use wesnoth.synchronize_choice or set
	-- any state after it finishes.

	wesnoth.show_dialog(dialog_definition, preshow)
end

