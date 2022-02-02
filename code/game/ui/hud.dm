/mob
	var/list/huds = list()

/mob/Login()
	..()
	for (var/hud/H in huds)
		H.show()

/mob/Del()
	remove_huds()
	..()

/mob/proc/remove_huds()
	for (var/hud/H in huds)
		H.remove()

/mob/proc/hide_huds(logout)
	for (var/hud/H in huds)
		H.hide(logout)

/hud
	var/visible = FALSE
	var/mob/owner
	var/list/hud_object/ui_objects = list()

/hud/New(mob/mob)
	owner = mob
	create_hud(mob)
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
	return ui_objects[name] = new path(src)

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
	if (!logout)
		visible = FALSE
	for (var/O in ui_objects)
		ui_objects[O].hide(owner.client)
		owner.client.screen -= ui_objects[O]

/hud/proc/logout()
	hide(TRUE)