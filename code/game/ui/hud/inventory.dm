/hud/inventory
	var/datum/inventory/inventory

/hud/inventory/create_hud()
	var/hud_object/button/B

	B = new_object(/hud_object/button, "throw")
	B.name = "throw"
	B.icon_state = "throw"
	B.click_handler = .proc/toggle_throw
	B.screen_loc = "EAST-1,SOUTH"

	B = new_object(/hud_object/button, "craft")
	B.name = "craft"
	B.icon_state = "craft"
	B.click_handler = .proc/toggle_craft
	B.screen_loc = "EAST-1,SOUTH"

/hud/inventory/proc/toggle_throw(hud_object/button/B)
	if (inventory.throw_mode)
		B.icon_state = "throw"
	else
		B.icon_state = "throw_a"
	inventory.throw_mode = !inventory.throw_mode

/hud/inventory/proc/toggle_craft(hud_object/button/B)
	if (inventory.craft_mode)
		B.icon_state = "craft"
	else
		B.icon_state = "craft_a"
	inventory.craft_mode = !inventory.craft_mode