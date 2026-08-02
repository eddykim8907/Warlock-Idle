#macro GAME_STATE_PLAYING 0
#macro GAME_STATE_PAUSED 1
#macro GAME_STATE_DEAD 2

#macro TICK_RATE 10
#macro TICK_INTERVAL (1 / TICK_RATE)

#macro STAT_ENTITY_PLAYER "player"
#macro STAT_ENTITY_TOTEM_BLEED "totem_bleed"

#macro MAP_TILE_SIZE 512
#macro MAP_CHUNK_MARGIN 1

#macro MAP_PROP_LAYER "Instances"

// GM2026: do not use built-in instance var names as struct keys (id, x, y, speed, etc.)
#macro STRUCT_UNSAFE_KEYS "id,x,y,speed,direction,depth,visible,sprite_index,image_index,entity,instances,type"

#macro VIEW_WIDTH 1366
#macro VIEW_HEIGHT 768
