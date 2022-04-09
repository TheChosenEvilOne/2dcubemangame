/datum/crafting_recipe
	var/name = "fuck"
	var/initiator_item
	var/use_initiator = TRUE
	var/list/steps

/datum/crafting_recipe/proc/check(atom/A)
	switch (steps["type"])
		if ("result")
			return TRUE
		if ("item")
			return istype(A, steps["object"])

/datum/crafting_recipe/proc/begin_craft(obj/item/initiator, atom/target)
	switch (steps["type"])
		if ("result")
			if (use_initiator)
				initiator.destroy()
			var/result = steps["object"]
			new result(get_step(target, 0))
		if ("item")
			if (steps["next"]["type"] == "result")
				var/result = steps["next"]["object"]
				new result(get_step(target, 0))
				if (use_initiator)
					initiator.destroy()
				if (steps["used"])
					target.destroy()
				return
			var/obj/item/craft/C = new (get_step(target, 0))
			if (use_initiator)
				C.add_item(initiator)
				initiator.destroy()
			if (steps["used"])
				C.add_item(target)
				target.destroy()
			C.current_step = steps["next"]