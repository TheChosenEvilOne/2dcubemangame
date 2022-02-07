var/global/atom/movable/abstract/new_player_holder = new

/mob/dead/new_player

/mob/dead/new_player/initialize()
	. = ..()
	new /hud/lobby(src)
	loc = new_player_holder