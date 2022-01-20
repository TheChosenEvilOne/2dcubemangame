/world
	fps = 30
	icon_size = 32

	view = 6
	turf = /turf/floor/gray
	mob = /mob/living/inventory/player
	maxz = 2
#if DM_VERSION > 513
	movement_mode = TILE_MOVEMENT_MODE
#endif

/world/New()
	clients = new()
	master = new()
	master.setup()
	..()

/world/Error(exception/E)
	if (server)
		server.say(E.name)
	..()