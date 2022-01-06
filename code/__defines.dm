#define ceil(x, y) -round(-x / y) * y
#define DELAY2GLIDESIZE(delay) (32 / max(ceil(delay / world.tick_lag, 1), 1))

//#define AREA_LAYER 1
//#define TURF_LAYER 2
//#define OBJ_LAYER 3
  #define ITEM_LAYER 3.1
//#define MOB_LAYER 4