--! [store_shroud]
--! melinath

-- Given side= and variable=, stores that side's shroud data in that variable
-- Example:
-- [store_shroud]
--     side=1
--     variable=shroud_data
-- [/store_shroud]

function wesnoth.wml_actions.store_shroud(cfg)
	local team_number = cfg.side or helper.wml_error("Missing required side= attribute in [store_shroud]")
	local variable = cfg.variable or helper.wml_error("Missing required variable= attribute in [store_shroud].")
	local side = wesnoth.get_side(team_number)
	local current_shroud = side.__cfg.shroud_data
	wesnoth.set_variable(variable, current_shroud)
end
