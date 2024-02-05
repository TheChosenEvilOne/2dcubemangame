/world
	fps = 30
	icon_size = 32

	view = 6
	turf = /turf/floor/gray
	mob = /mob/dead/new_player
#if DM_VERSION > 513
	movement_mode = TILE_MOVEMENT_MODE
#endif

/world/New()
	clients = new()
	master = new()
	new /admin_verbs()
	master.setup()
	..()

var/global/list/exceptions = list()
/world/Error(exception/E)
	if (server)
		server.say(E.name)
	exceptions += E
	..()

/world/Topic(T, Addr, Master, Keys)
	return T