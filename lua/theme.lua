---
-- Sets up sidebar icons for custom unit statuses.
---

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-utbs"
local old_unit_status = wesnoth.theme_items.unit_status

function wesnoth.theme_items.unit_status()
	local u = wesnoth.get_displayed_unit()
	if not u then return {} end
	local s = old_unit_status()

	if u.variables.uu_immobilized then
		-- FIXME: uu_immobilized should probably be promoted to an actual
		--        [status] member at some point, but a lot of code in
		--        unit-utils.cfg needs to be changed for that purpose.
		table.insert(s, { "element", {
			image = "misc/bound-status-icon.png",
			tooltip = _ "bound: This unit is bound to the movement range of another unit by a spell."
		}})
	end
	if u.status.stunned then
		table.insert(s, { "element", {
			image = "misc/stunned-status-icon.png",
			tooltip = _ "stunned: This unit is stunned. It cannot enforce its Zone of Control."
		}})
	end

	return s
end
