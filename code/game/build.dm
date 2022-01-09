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
		/turf/floor/gray,
		/turf/floor/white,
		/turf/floor/dort,
		/turf/floor/grass,
		/turf/floor/wood,
		/turf/floor/sand,
		/turf/floor/marsh,
		/turf/floor/water,
		/turf/floor/water/lava,
		/obj/window,
		/obj/campfire,
		/obj/torch,
		/obj/path,
		/obj/chair,
		/obj/table
	)

/datum/builder/New(mob/mob)
	owner = mob
	build_type = buildable[1]
	hud = new /hud/build(mob, src)
	mob.click_intercept[src] = .proc/click_handler

/datum/builder/proc/click_handler(atom/object, location, control, params)
	if (!owner.building)
		return FALSE
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
	return TRUE

/mob
	var/building = FALSE
	var/datum/builder/builder

/mob/proc/toggle_build()
	if (!builder)
		builder = new(src)
	building = !building
	if (building)
		builder.hud.show()
		src << "enabled building."
	else
		builder.hud.hide()
		src << "disabled building."

/client/verb/toggle_build()
	set name = "Build"
	mob.toggle_build()