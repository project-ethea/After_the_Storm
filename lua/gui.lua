---
-- Lua WML actions implementing custom GUI2 dialogs.
---

local helper = wesnoth.require "lua/helper.lua"

-- metatable for GUI tags
local T = helper.set_wml_tag_metatable {}

---
-- Displays a transparent message box that's dimissed when clicked.
--
-- [transient_message]
--     caption=(tstring)
--     message=(tstring)
--     transparent=(boolean)
--     image=(image path)
--     sound=(string)
-- [/transient_message]
---
function wesnoth.wml_actions.transient_message(cfg)
	-- HACK: Don't set a border size for the image cell when
	--       there's no image to display; this way it doesn't
	--       result in some empty space to the left of the text.
	local image_margin = 0
	if cfg.image ~= nil then
		image_margin = 5
	end

	local dd = {
		maximum_width = 800,
		maximum_height = 600,
		click_dismiss = true,
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field

		T.grid {
			T.row {
				T.column {
					border = "all", border_size = image_margin,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					T.image { id = "image" }
				},
				T.column {
					T.grid {
						T.row {
							T.column {
								border = "all", border_size = 5,
								vertical_alignment = "top",
								horizontal_alignment = "left",
								T.label {
									id = "caption",
									definition = "title"
								}
							}
						},
						T.row {
							T.column {
								border = "all", border_size = 5,
								vertical_alignment = "top",
								horizontal_alignment = "left",
								T.label {
									id = "message",
									definition = "wml_message",
									wrap = true
								}
							}
						}
					}
				}
			}
		}
	}

	local transparent = cfg.transparent
	if transparent == nil then transparent = true end

	if transparent then
		dd.definition = "message"
	end

	local caption = cfg.caption
	if caption == nil then caption = "" end
	local message = cfg.message
	if message == nil then message = "" end

	local function preshow()
		wesnoth.set_dialog_value(caption, "caption")
		wesnoth.set_dialog_value(message, "message")

		if cfg.image then
			wesnoth.set_dialog_value(cfg.image, "image")
		end
	end

	local sound = cfg.sound
	if sound ~= nil then wesnoth.play_sound(sound) end

	wesnoth.show_dialog(dd, preshow, nil)
end

---
-- Displays a simple transient message at the top, without any
-- captions or images.
--
-- [top_message]
--     message=(tstring)
-- [/top_message]
---
function wesnoth.wml_actions.top_message(cfg)
	local dd = {
		definition = "message",

		vertical_placement = "top",
		horizontal_placement = "center",

		-- TODO: we can't use manual placement yet because then the width and height
		--       become static and the game fails if the text doesn't fit later.
		--
		-- automatic_placement = false,
		-- x = "(screen_width / 2)",
		-- the menu bar height (26 px) plus the standard margin size
		-- y = "(26 + 5)",
		-- width = 200,
		-- height = 100,

		maximum_width = 800,
		maximum_height = 600,

		click_dismiss = true,

		T.helptip { id="tooltip_large" },
		T.tooltip { id="tooltip_large" },

		T.grid {
			T.row {
				T.column {
					border = "all", border_size = 20,
					horizontal_alignment = "center",
					vertical_alignment = "center",
					T.label { id = "message", definition = "default" }
				}
			}
		}
	}

	local message = cfg.message
	if message == nil then message = "" end

	local function preshow()
		wesnoth.set_dialog_value(message, "message")
	end

	wesnoth.show_dialog(dd, preshow, nil)
end

---
-- Displays an image on a popup dialog.
--
-- [show_image]
--     image= ...
-- [/show_image]
---
function wesnoth.wml_actions.show_image(cfg)
	local function do_error(msg)
		helper.wml_error("[show_image]: " .. msg)
	end

	local img = cfg.image or do_error("required 'image' attribute is missing")

	local dd = {
		-- NOTE: Can't use transparency until mainline #19165 is fixed!
		-- definition = "message",
		maximum_width = 800,
		maximum_height = 480,
		click_dismiss = true,
		T.helptip { id="tooltip_large" }, -- mandatory field
		T.tooltip { id="tooltip_large" }, -- mandatory field
		T.grid {
			T.row {
				T.column {
					border = "all", border_size = 5,
					T.image {
						id = "image", definition = "default"
					}
				}
			}
		}
	}

	local function preshow()
		wesnoth.set_dialog_value(img, "image")
	end

	wesnoth.show_dialog(dd, preshow, nil)
end

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
					return_value_id = "ok",
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
