/obj/item/craft
	name = "unfinished craft"
	icon = null
	var/crafting_recipe/recipe
	var/list/current_step

/obj/item/craft/left_click(adjacent, params, obj/item)
	if (!adjacent)
		return
	switch (current_step["type"])
		if ("item")
			if (!istype(item, current_step["object"]))
				return
			if (current_step["next"]["type"] == "result")
				var/R = current_step["next"]["object"]
				new R(get_step(src, 0))
				if (current_step["used"])
					item.destroy()
				destroy()
				return
			if (current_step["used"])
				add_item(item)
				item.destroy()
			current_step = current_step["next"]

/obj/item/craft/proc/add_item(atom/A)
	var/image/I = new(A.appearance)
	I.pixel_x = rand(-16, 16)
	I.pixel_y = rand(-16, 16)
	overlays += I