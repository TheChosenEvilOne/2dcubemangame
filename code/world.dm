/world
	fps = 30
	icon_size = 32

	view = 6
	turf = /turf/floor/gray
	mob = /mob/living/inventory/player
	movement_mode = TILE_MOVEMENT_MODE

/world/New()
	master = new()
	..()

/world/Error(exception/E)
	if (server)
		server.say(E.name)
	..()