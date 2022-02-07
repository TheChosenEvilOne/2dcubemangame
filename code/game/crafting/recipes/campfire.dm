/datum/crafting_recipe/campfire
	name = "campfire"
	initiator_item = /obj/item/wood
	steps = list(
		"type" = "item",
		"object" = /obj/item/wood,
		"used" = TRUE,
		"next" = list(
			"type" = "item",
			"object" = /obj/item/wood,
			"used" = TRUE,
			"next" = list(
				"type" = "item",
				"object" = /obj/item/rock,
				"used" = FALSE,
				"next" = list(
					"type" = "result",
					"object" = /obj/campfire,
				)
			)
		)
	)