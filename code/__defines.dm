#define ceil(x, y) -round(-x / y) * y
#define subtypesof(x) typesof(x) - x
#define DELAY2GLIDESIZE(delay) (32 / max(ceil(delay / world.tick_lag, 1), 1))
#define HALF_ICON_SIZE 16
#define ICON_SIZE 32
#define NONE 0
#define ALL_DIRECTIONS list(NORTH, SOUTH, EAST, WEST, NORTHWEST, NORTHEAST, SOUTHWEST, SOUTHEAST)
#define CARDINAL_DIRECTIONS list(NORTH, SOUTH, EAST, WEST)

#define STATUS_ALIVE	0
#define STATUS_DEAD		1

#define NOT_ADJACENT		0
#define WORLD_ADJACENT		1
#define INVENTORY_ADJACENT	2

#define GROUND	0
#define FLYING	1

#define ADMIN_VERB(group, id, _name) \
/admin_verbs/New() {\
	..();\
	register_admin_verb(#group, #id, /admin_verbs/verb/##id)\
}\
/admin_verbs/verb/##id() {\
	set name = #_name;\
	set category = #group;\
	if (admin_permission_check(#group, #id)) {\
		call(/admin_verbs/proc/##group_##id)();\
	}\
}\
/admin_verbs/proc/##group_##id()

#define DATUM_PROCESS			1
#define DATUM_PROCESSING		2

#define SYSTEM_CREATE(x) 		\
var/global/system/x/sys_##x;	\
/system/##x/New(){				\
sys_##x = src					\
}								\
/system/##x

// common processing system, used for all /datum/game_objects
#define PROCESSING_CREATE(x)			\
var/global/system/processing/x/sys_##x;	\
/system/processing/##x/New(){			\
sys_##x = src							\
}										\
/system/processing/##x

#define MAPTEXT(text) "<span class='maptext'>[text]</span>"
#define CENTERTEXT(text) "<span class='center'>[text]</span>"
#define SMALLTEXT(text) "<span class='small'>[text]</span>"
#define LARGETEXT(text) "<span class='large'>[text]</span>"

#define GET_CONF(conf) (sys_config.configs[conf])

// actual infinity, epic.
#define INFINITY 1#INF

#define check_cpu if (world.cpu > allowed_cpu_time) {sleep(world.tick_lag)}

#define S_INIT		1
#define S_PROCESS	2
#define S_PAUSED	4

//#define AREA_LAYER 1
#define BELOW_TURF_LAYER 1.5
//#define TURF_LAYER 2
#define UNDER_OBJ_LAYER 2.9
//#define OBJ_LAYER 3
#define ITEM_LAYER 3.1
#define UNDER_MOB_LAYER 3.9
//#define MOB_LAYER 4
#define ABOVE_MOB_LAYER 4.1
#define UNDER_LIGHTING_LAYER 99
#define LIGHTING_LAYER 100
#define OVER_LIGHTING_LAYER 101
#define UI_LAYER 200

#define BELOW_PLANE -100
#define TURF_PLANE -95
#define WORLD_PLANE -80
#define LIGHTING_PLANE -60
#define UI_PLANE -40
// REMEMBER, ANYTHING ABOVE PLANE 0 IS DRAWN ABOVE FOV DARKNESS ???