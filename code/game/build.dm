#define BUILDING 0
#define PAINTING 1

/datum/builder
	var/mob/owner
	var/hud/build/hud
	var/mode = BUILDING
	var/colour = "#fff"
	var/atom/build_type
	var/list/buildable = list(
		/obj/door,
		/obj/door/automatic,
		/turf/wall,
		/turf/wall/rock,
		/turf/wall/rock/gray,
		/turf/floor/white,
		/turf/floor/dort,
		/turf/floor/grass,
		/turf/floor/wood,
		/obj/window,
		/obj/campfire,
		/obj/table
	)

/datum/builder/New(mob/mob)
	owner = mob
	build_type = buildable[1]
	hud = new /hud/build(mob, src)
	mob.click_intercept[src] = .proc/click_handler

/datum/builder/proc/click_handler(atom/object, location, control, params)
	if (!owner.building)
		return
	if (params["left"])
		if (mode == BUILDING)
			new build_type(location)
		else
			object.color = colour
	if (params["right"])
		if (mode == BUILDING)
			object.destroy()
		else
			object.color = null
	return 1

/mob
	var/building = 0
	var/datum/builder/builder

/mob/Del()
	if (builder && builder.hud)
		builder.hud.remove()
	del builder
	builder = null
	. = ..()

/client/verb/toggle_build()
	set name = "Build"
	if (!mob.builder)
		mob.builder = new(mob)
	mob.building = !mob.building
	if (mob.building)
		mob.builder.hud.show()
		mob << "enabled building."
	else
		mob.builder.hud.hide()
		mob << "disabled building."
