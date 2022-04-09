/datum/crafting_recipe/sword
	name = "sword"
	initiator_item = /obj/item/wood
	steps = list(
		"type" = "item",
		"object" = /obj/item/rock,
		"used" = TRUE,
		"next" = list(
			"type" = "result",
			"object" = /obj/item/sword
		)
	)