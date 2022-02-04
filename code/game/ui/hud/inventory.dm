/hud/inventory
	var/datum/inventory/inventory

/hud/inventory/create_hud()
	var/hud_object/button/B

	B = new_object(/hud_object/button, "throw")
	B.name = "throw"
	B.icon_state = "throw"
	B.click_handler = .proc/toggle_throw
	B.screen_loc = "SOUTH,EAST-1"

/hud/inventory/proc/toggle_throw(hud_object/button/B)
	if (inventory.throw_mode)
		inventory.throw_mode = FALSE
		B.icon_state = "throw"
	else
		inventory.throw_mode = TRUE
		B.icon_state = "throw_a"