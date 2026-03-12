local T = wml.tag

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

local list_definition = {
	T.row {
		T.column {
			vertical_grow = true,
			horizontal_grow = true,
			T.toggle_panel {
				definition = "fancy",
				return_value_id = "ok",
				T.grid {
					T.row {
						T.column {
							T.spacer {
								width = 10
							}
						},
						T.column {
							grow_factor = 1,
							horizontal_grow = true,
							border = "all",
							border_size = 10,
							T.label {
								id = "item",
								definition = "default",
								linked_group = "item"
							}
						},
						T.column {
							T.spacer {
								-- Intentionally wider than the left margin
								-- because it looks better this way in
								-- Latin scripts at least (not sure why)
								width = 20
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
			-- NOTE on margins (borders, whatever)
			-- Having margins on the top, left and right but NOT bottom somehow
			-- tends to look better when dealing with unit art as it brings the
			-- icons closer to the listbox. I'm not sure why it looks better,
			-- it just does. It might have something to do with the sprite body
			-- proportions and how legs are usually positioned in frame.
			T.column {
				grow_factor = 1,
				T.grid {
					T.row {
						grow_factor = 1,
						T.column {
							grow_factor = 0,
							border = "top,left,right",
							border_size = 10,
							T.panel {
								id = "primary_unit",
								T.grid {
									T.row {
										T.column {
											grow_factor = 1,
											border = "all",
											border_size = 5,
											T.label {
												id = "primary_unit_name",
												definition = "default_large"
											}
										}
									},
									T.row {
										T.column {
											grow_factor = 0,
											border = "top,left,right",
											border_size = 5,
											T.image {
												id = "primary_unit_icon"
											}
										}
									}
								}
							}
						},
						T.column {
							T.spacer {
								width = 30
							}
						},
						T.column {
							border = "all",
							border_size = 10,
							vertical_grow = true,
							T.drawing {
								width = 1,
								height = "(height)",
								T.draw {
									T.line {
										x1 = 0,
										y1 = 1,
										x2 = 0,
										y2 = "(height - 1)",
										color = "114, 79, 46, 255",
										thickness= 1
									}
								}
							}
						},
						T.column {
							T.spacer {
								width = 30
							}
						},
						T.column {
							grow_factor = 0,
							border = "top,left,right",
							border_size = 10,
							T.panel {
								id = "secondary_unit",
								T.grid {
									T.row {
										T.column {
											grow_factor = 1,
											border = "all",
											border_size = 5,
											T.label {
												id = "secondary_unit_name",
												definition = "default_large"
											}
										}
									},
									T.row {
										T.column {
											grow_factor = 0,
											border = "top,left,right",
											border_size = 5,
											T.image {
												id = "secondary_unit_icon"
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
			T.column {
				grow_factor = 1,
				horizontal_grow = true,
				vertical_grow = true,
				-- See note on margins in the top row
				border = "left,right,bottom",
				border_size = 10,
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

local function ipf_compose_blit(path, src)
	return ("%s~BLIT(%s)"):format(path, src)
end

local function get_unit_icon(unit, flip)
	local ut = wesnoth.unit_types[unit.type]
	if unit.variation and unit.variation ~= "" then
		ut = ut.variations[unit.variation]
	end
	ut = ut.variations[unit.gender]

	local side = wesnoth.sides[unit.side]
	local icon = "misc/blank-hex.png"

	if ut.icon and ut.icon ~= "" then
		icon = ut.icon
	elseif ut.image and ut.image ~= "" then
		icon = ut.image
	end

	icon = ("%s~RC(magenta>%s)"):format(icon, side.color)

	if flip then
		icon = icon .. "~FL()"
	end

	--[[
	-- FIXME: can't figure out how to make overlays look good and have
	-- more pressing things to do right now
	if unit.canrecruit then
		icon = ipf_compose_blit(icon, "misc/leader-crown.png")
	end

	if unit.overlays then
		for i, ov in ipairs(unit.overlays) do
			icon = ipf_compose_blit(icon, ov)
		end
	end
	]]--

	local w, h = filesystem.image_size(icon)
	-- FIXME: flag_rgb is not documented as a field of unit/unit type data, so
	-- not sure if it would be present and non-empty if a unit had a custom
	-- value. For now I feel it's perfectly fine to assume magenta anyhow.
	return ("%s~SCALE_SHARP(%d,%d)~RC(magenta>%s)"):format(icon, w*2, h*2, side.color)
end

local show_unit_names = false

---
-- [character_action_dialog]
--     variable=choice
--     can_dismiss=true
--     auto_units=false # optional
--     [primary_unit] # optional
--         ... SUF ...
--     [/primary_unit]
--     [secondary_unit] # optional
--         ... SUF ...
--     [/secondary_unit]
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

	local auto_units = not not cfg.auto_units
	local context = wesnoth.current.event_context

	local primary_unit_cfg = wml.get_child(cfg, "primary_unit")
	local secondary_unit_cfg = wml.get_child(cfg, "secondary_unit")

	local primary_unit, secondary_unit = nil, nil

	if auto_units and context then
		-- We let these be overridden by [primary/secondary_unit] if present
		if context.x1 then
			primary_unit = wesnoth.units.get(context.x1, context.y1)
		end
		if context.x2 then
			secondary_unit = wesnoth.units.get(context.x2, context.y2)
		end
	end

	if primary_unit_cfg then
		primary_unit = wesnoth.units.find_on_map(cfg)
		if primary_unit then
			primary_unit = primary_unit[1]
		end
	end

	if secondary_unit_cfg then
		secondary_unit = wesnoth.units.find_on_map(cfg)
		if primary_unit then
			secondary_unit = secondary_unit[1]
		end
	end

	local res = wesnoth.sync.evaluate_single(function()
		local choice = 0

		local function preshow(self)
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

			self.primary_unit.visible = not not primary_unit
			if primary_unit then
				-- FIXME hide names until I can decide if they can be made to look good
				self.primary_unit_name.visible = show_unit_names
				self.primary_unit_name.label = primary_unit.name
				self.primary_unit_icon.label = get_unit_icon(primary_unit)
			end

			self.secondary_unit.visible = not not secondary_unit
			if secondary_unit then
				-- FIXME hide names until I can decide if they can be made to look good
				self.secondary_unit_name.visible = show_unit_names
				self.secondary_unit_name.label = secondary_unit.name
				self.secondary_unit_icon.label = get_unit_icon(secondary_unit, true)
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
