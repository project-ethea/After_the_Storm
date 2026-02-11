local T = wml.tag

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

function wesnoth.wml_actions.gate_glyph_input(cfg)
	local min_value = cfg.min or 0
	local max_value = cfg.max or 100
	local variable = cfg.variable or wml.error("[gate_glyph_input] variable= required")
	local hex = not not cfg.hex

	local dlg_controls_grid = {
		T.row {
			T.column {
				grow_factor = 0,
				border = "all",
				border_size = 5,
				T.button {
					id = "ok",
					label = _ "Submit",
				}
			},
			--[[
			T.column {
				grow_factor = 0,
				border = "all",
				border_size = 5,
				T.button {
					id = "cancel",
					label = wgettext("Cancel"),
				}
			}
			]]--
		}
	}

	local freq_controls_grid = {
		T.row {
			T.column {
				grow_factor = 1,
				horizontal_grow = true,
				border = "all",
				border_size = 5,
				T.label {
					id = "value_display",
					definition = "gold_large",
					label = "value display",
					text_alignment = "center",
				}
			}
		},
		T.row {
			T.column {
				T.grid {
					T.row {
						T.column {
							grow_factor = 0,
							border = "all",
							border_size = 5,
							T.repeating_button {
								id = "value_sub",
								definition = "left_arrow",
							}
						},
						T.column {
							grow_factor = 1,
							horizontal_grow = true,
							border = "all",
							border_size = 5,
							T.slider {
								id = "freq_value",
								definition = "minimal",
								minimum_value = min_value,
								maximum_value = max_value,
							}
						},
						T.column {
							grow_factor = 0,
							border = "all",
							border_size = 5,
							T.repeating_button {
								id = "value_add",
								definition = "right_arrow",
							}
						},
					}
				}
			}
		}
	}

	local dialog = {
		maximum_width = 600,
		maximum_height = 600,

		T.helptip { id = "tooltip_large" },
		T.tooltip { id = "tooltip_large" },

		T.grid {
			T.row {
				T.column {
					T.spacer {}
				},
				T.column {
					grow_factor = 1,
					horizontal_grow = true,
					border = "all",
					border_size = 5,
					T.label {
						definition = "title",
						label = _ "Adjust Frequency"
					}
				}
			},
			T.row {
				T.column {
					grow_factor = 0,
					border = "all",
					border_size = 5,
					T.image {
						label = "items/crystal-glyph-gate.png~SCALE_SHARP(144,144)"
					}
				},
				T.column {
					vertical_grow = true,
					border = "all",
					border_size = 5,
					T.panel {
						definition = "naia_journeylog_panel",
						T.grid(freq_controls_grid)
					}
				}
			},
			T.row {
				T.column {
					T.spacer {}
				},
				T.column {
					grow_factor = 0,
					horizontal_alignment = "right",
					T.grid(dlg_controls_grid),
				}
			}
		}
	}

	local res = wesnoth.sync.evaluate_single(function ()
		local value = min_value

		if wml.variables[variable] ~= nil then
			value = wml.variables[variable]
		end

		local function update_display(self)
			local fmt = "%d"
			if hex then
				fmt = "0x%04X"
			end
			self.value_display.label = fmt:format(value)
			self.value_sub.enabled = not (value <= min_value)
			self.value_add.enabled = not (value >= max_value)
		end

		local function preshow(self)
			self.freq_value.on_modified = function()
				value = self.freq_value.value
				update_display(self)
			end

			self.value_sub.on_button_click = function()
				self.freq_value.value = math.max(self.freq_value.value - 1, min_value)
			end

			self.value_add.on_button_click = function()
				self.freq_value.value = math.min(self.freq_value.value + 1, max_value)
			end

			self.freq_value.value = value
			update_display(self)
		end

		local res = gui.show_dialog(dialog, preshow)
		if res == -1 then
			return { value = value }
		else
			return {}
		end
	end)

	-- Commit
	if res.value ~= nil then
		wml.variables[variable] = res.value
	end
end
