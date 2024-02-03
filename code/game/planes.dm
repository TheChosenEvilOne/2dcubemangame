/plane
	parent_type = /atom/movable
	name = "plane"
	screen_loc = "1,1"
	appearance_flags = PLANE_MASTER | NO_CLIENT_COLOR

/plane/initialize()

/plane/below
	color = "#AAA"
	plane = BELOW_PLANE

/plane/turf_wall
	plane = TURF_WALL_PLANE

/plane/turf_wall/initialize()
	filters += filter(type="drop_shadow", x=0, y=-2, size=4, color="#04080FAA")

/plane/world
	plane = WORLD_PLANE

/plane/lighting
	blend_mode = BLEND_MULTIPLY
	plane = LIGHTING_PLANE

/plane/ui
	plane = UI_PLANE