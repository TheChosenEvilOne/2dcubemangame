/datum/crafting_recipe/pickaxe
	name = "pickaxe"
	initiator_item = /obj/item/wood
	steps = list(
		"type" = "item",
		"object" = /obj/item/rock,
		"used" = TRUE,
		"next" = list(
			"type" = "result",
			"object" = /obj/item/pickaxe
		)
	)