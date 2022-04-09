SYSTEM_CREATE(crafting)
	name = "crafting"
	flags = S_INIT
	priority = 1000
	var/list/recipes = list()

/system/crafting/initialize()
	for (var/datum/crafting_recipe/R as anything in subtypesof(/datum/crafting_recipe))
		var/I = initial(R.initiator_item)
		if (!recipes[I])
			recipes[I] = list()
		recipes[I] += new R