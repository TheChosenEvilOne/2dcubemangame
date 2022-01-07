#define ceil(x, y) -round(-x / y) * y
#define subtypesof(x) typesof(x) - x
#define DELAY2GLIDESIZE(delay) (32 / max(ceil(delay / world.tick_lag, 1), 1))

#define DATUM_PROCESS		1

#define SYSTEM_CREATE(x) var/global/system/x/sys_##x;	\
/system/##x/New(){										\
sys_##x = src											\
}														\
/system/##x
#define PROCESSING_CREATE(x) var/global/system/processing/x/sys_##x;\
/system/processing/##x

#define check_cpu if (world.cpu > allowed_cpu_time) {sleep(world.tick_lag)}

#define S_INIT		1
#define S_PROCESS	2

//#define AREA_LAYER 1
//#define TURF_LAYER 2
//#define OBJ_LAYER 3
  #define ITEM_LAYER 3.1
//#define MOB_LAYER 4
#define LIGHTING_LAYER 100
#define OVER_LIGHTING_LAYER 101