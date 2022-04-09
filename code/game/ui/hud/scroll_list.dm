/hud/scroll_list
	var/hud/parent
	var/click_handler

/hud/scroll_list/create_hud(mob, width, height, _parent, handler, list/list)
	parent = _parent
	click_handler = handler
	if (!parent || !click_handler)
		CRASH("Attempted to create scroll list without proper parent and/or click handler.")

	var/w = width / 2 + 0.5
	var/h = height / 2 + 0.5

	var/hud_object/icon/I
	I = new_object(/hud_object/icon, "ul")
	I.screen_loc = "CENTER-[w],CENTER+[h]"
	I.icon_state = "lu"
	I = new_object(/hud_object/icon, "ur")
	I.icon_state = "ru"
	I.screen_loc = "CENTER+[w],CENTER+[h]"
	I = new_object(/hud_object/icon, "ld")
	I.icon_state = "ld"
	I.screen_loc = "CENTER-[w],CENTER-[h]"
	I = new_object(/hud_object/icon, "rd")
	I.icon_state = "rd"
	I.screen_loc = "CENTER+[w],CENTER-[h]"

	for (var/x in (1 - w) to (w - 1))
		I = new_object(/hud_object/icon, "u[x]")
		I.icon_state = "u"
		I.screen_loc = "CENTER+[x],CENTER+[h]"
		I = new_object(/hud_object/icon, "d[x]")
		I.icon_state = "d"
		I.screen_loc = "CENTER+[x],CENTER-[h]"

	for (var/y in (1 - h) to (h - 1))
		I = new_object(/hud_object/icon, "l[y]")
		I.icon_state = "l"
		I.screen_loc = "CENTER-[w],CENTER+[y]"
		I = new_object(/hud_object/icon, "r[y]")
		I.icon_state = "r"
		I.screen_loc = "CENTER+[w],CENTER+[y]"

	var/i = 1
	for (var/y in (1 - h) to (h - 1))
		for (var/x in (1 - w) to (w - 1))
			var/ind = (h - y - 1) + (w - x - 1) * height
			var/hud_object/button/B = new_object(/hud_object/button, "[ind]")
			B.icon_state = "b"
			B.screen_loc = "CENTER+[x],CENTER+[height - y - height]"
			B.click_handler = .proc/handle_click
			if (list && list.len >= i)
				B.hicon.icon = list[i][1]
				B.name = list[i][2]
				B.value = list[i++][3]
			else
				B.name = ""

/hud/scroll_list/proc/handle_click(hud_object/button/B, params)
	if (!B.value)
		return
	call(parent, click_handler)(B.value)