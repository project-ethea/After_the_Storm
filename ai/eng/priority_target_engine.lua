--
-- Code taken from the AI Modification Demos add-on by mattsc.
--
-- Extended to allow considering any unit from a list of potential targets,
-- with some help from the RNG.
--

return {
	init = function(ai)

		local priority_target = {}

		local H = wesnoth.require "lua/helper.lua"
		local W = H.set_wml_action_metatable {}

		function priority_target:change_attacks_aspect(target_ids)
			-- Set 'attacks' aspect so that only unit with id=target_id
			-- is attacked if it can be reached, delete aspect otherwise

			-- The following can be simplified significantly once the 'attacks' variable is available
			-- All units that have attacks left (but are not leaders)
			local attackers = wesnoth.get_units{side = wesnoth.current.side, canrecruit = "yes", formula = "$this_unit.attacks_left > 0"}
			--print("\nAttackers:",#attackers)

			-- This is the list of reachable targets from the target_ids table.
			-- It's just for internal state tracking in the reachable units loop.
			local targets_in_reach = {}

			for i, target_id in ipairs(target_ids) do
				--print(target_id .. " is a candidate")
				targets_in_reach.target_id = false
			end

			-- This is the actual list of candidate units to choose from using
			-- the RNG later on.
			local rand_op_str = ''

			-- See if any of those units can reach our target(s)
			for i, u in ipairs(attackers) do
				for j, target_id in ipairs(target_ids) do
					if targets_in_reach.target_id == false then
						--print(string.format("Considering target %s for %s", target_id, u.id))

						-- Need to find reachable hexes that are
						-- 1. next to target
						-- 2. not occupied by an allied unit (except for unit itself)
						W.store_reachable_locations {
							{ "filter", { id = u.id } },
							{ "filter_location", {
								{ "filter_adjacent_location", {
									{ "filter", { id = target_id } }
								} },
								{ "not", {
									{ "filter", { { "not", { id = u.id } } } }
								} }
							} },
							moves = "current",
							variable = "tmp_locs"
						}
						local tir = H.get_variable_array("tmp_locs")
						W.clear_variable { name = "tmp_locs" }
						--print("reachable locs:",u.id,#tir)

						-- If the unit can reach the target, set its flag on the
						-- targets_in_reach table and append it to the RNG call
						-- string
						if (#tir > 0) then
							targets_in_reach.target_id = true

							if string.len(rand_op_str) == 0 then
								rand_op_str = target_id
							else
								rand_op_str = rand_op_str .. ',' .. target_id
							end
						end
					end
				end
			end

			-- Always delete the attacks aspect first, so that we do not end up with 100 copies of the facet
			--print("Deleting attacks aspect")
			W.modify_ai {
				side = wesnoth.current.side,
				action = "try_delete",
				path = "aspect[attacks].facet[limited_attack]"
			}

			-- Also delete aggression, caution - for the same reason
			W.modify_ai {
				side = wesnoth.current.side,
				action = "try_delete",
				path = "aspect[aggression].facet[*]"
			}
			W.modify_ai {
				side = wesnoth.current.side,
				action = "try_delete",
				path = "aspect[caution].facet[*]"
			}

			local target_id = ''

			-- Choose a target if we found any reachable targets.

			if string.len(rand_op_str) > 0 then
				--print(string.format("Randomize target: %s", rand_op_str))
				target_id = safe_random(rand_op_str)
			end

			if string.len(target_id) > 0 then
				--print("Setting attacks aspect (" .. target_id .. ")")
				W.modify_ai {
					side = wesnoth.current.side,
					action = "add",
					path = "aspect[attacks].facet",
					{ "facet", {
						name = "testing_ai_default::aspect_attacks",
						id = "limited_attack",
						invalidate_on_gamestate_change = "yes",
						{ "filter_enemy", { id = target_id } }
					} }
				}

				-- We also want to set
				-- 'aggression=1' and 'caution=0', otherwise there could be turns on which nothing happens
				W.modify_side {
						side = wesnoth.current.side,
						{ "ai", { aggression = 1, caution = 0 } }
				}
			end

			return 0
		end

		return priority_target
	end
}
