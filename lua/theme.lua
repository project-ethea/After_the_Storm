---
-- Sets up sidebar icons for custom unit statuses.
---

-- #textdomain wesnoth-After_the_Storm
local _ = wesnoth.textdomain "wesnoth-After_the_Storm"

register_unit_status_display {
	id      = "stunned",
	icon    = "misc/stunned-status-icon.png",
	tooltip = _ "stunned: This unit is stunned. It cannot enforce its Zone of Control.",
}

register_unit_status_display {
	id      = "dazed",
	icon    = "misc/dazed-status-icon.png",
	tooltip = _ "dazed: This unit is dazed. It suffers a -10% penalty to both its defense and chance to hit (except for magical attacks).",
}

register_unit_status_display {
	id      = "absconding",
	icon    = "misc/absconding-status-icon.png",
	tooltip =  _ "absconding: This unit made use of its absconding ability during its previous turn.",
}

-- FIXME: uu_immobilized should probably be promoted to an actual
--        [status] member at some point, but a lot of code in
--        unit-utils.cfg needs to be changed for that purpose.

register_unit_status_display {
	id      = "uu_immobilized",
	icon    = "misc/bound-status-icon.png",
	tooltip = _ "bound: This unit is bound to the movement range of another unit by a spell.",
	source  = "variables"
}
