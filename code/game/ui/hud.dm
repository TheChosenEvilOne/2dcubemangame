/mob
	var/list/huds = list()

/mob/Login()
	. = ..()
	for (var/hud/H in huds)
		if (H.show_on_login)
			H.show()

/mob/Logout()
	hide_huds()
	. = ..()

/mob/Del()
	remove_huds()
	. = ..()

/mob/proc/remove_huds()
	for (var/hud/H in huds)
		H.remove()

/mob/proc/hide_huds(logout)
	for (var/hud/H in huds)
		H.hide(logout)

/hud
	var/show_on_login = TRUE
	var/visible = FALSE
	var/mob/owner
	var/list/hud_object/ui_objects = list()

/hud/New(mob/mob)
	owner = mob
	create_hud(arglist(args))
	for (var/O in ui_objects)
		if (!ui_objects[O].screen_loc)
			CRASH("HUD object [O] has invalid screen location.")
		ui_objects[O].setup()
	mob.huds += src

/hud/proc/remove()
	hide()
	for (var/O in ui_objects)
		ui_objects[O].remove()
	ui_objects.Cut()
	owner.huds -= src
	owner = null

/hud/proc/new_object(path, name)
	if (ui_objects[name])
		CRASH("tried to replace existing ui object [name] in [src].")
	var/hud_object/H = new path(src)
	H.id = name
	return ui_objects[name] = H

/hud/proc/create_hud(mob)
	CRASH("Attempted to create invalid HUD")

/hud/proc/show()
	if (visible || !owner || !owner.client)
		return
	visible = TRUE
	for (var/O in ui_objects)
		ui_objects[O].show(owner.client)
		owner.client.screen += ui_objects[O]

/hud/proc/hide(logout = FALSE)
	if (!visible || !owner || !owner.client)
		return
	visible = FALSE
	for (var/O in ui_objects)
		ui_objects[O].hide(owner.client)
		owner.client.screen -= ui_objects[O]