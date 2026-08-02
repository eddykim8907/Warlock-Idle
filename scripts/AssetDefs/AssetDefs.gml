#macro ASSET_SPRITE spr_assets

#macro ASSET_FRAME_PLAYER_WAND 14
#macro ASSET_FRAME_STAGE_1_MOB 41

#macro ASSET_FRAME_MAP_FIRE 84
#macro ASSET_FRAME_MAP_PALACE 100
#macro ASSET_FRAME_MAP_HUT 101
#macro ASSET_FRAME_MAP_ROOF 103
#macro ASSET_FRAME_MAP_HOUSE 104
#macro ASSET_FRAME_MAP_THREE_TREES 105
#macro ASSET_FRAME_MAP_TREE 107
#macro ASSET_FRAME_MAP_TREE2 108

/// @description Weighted random map decoration frame from spr_assets
function asset_defs_pick_map_frame() {
	var _roll = random(100);
	if (_roll < 3) return ASSET_FRAME_MAP_PALACE;
	if (_roll < 11) return ASSET_FRAME_MAP_FIRE;
	if (_roll < 26) return ASSET_FRAME_MAP_HOUSE;
	if (_roll < 38) return ASSET_FRAME_MAP_HUT;
	if (_roll < 50) return ASSET_FRAME_MAP_ROOF;
	if (_roll < 62) return ASSET_FRAME_MAP_THREE_TREES;
	if (_roll < 81) return ASSET_FRAME_MAP_TREE;
	return ASSET_FRAME_MAP_TREE2;
}

/// @description Parallax depth for a map prop frame (0 = far background, 1 = near)
function asset_defs_map_parallax(_frame) {
	switch (_frame) {
		case ASSET_FRAME_MAP_TREE:
		case ASSET_FRAME_MAP_TREE2:
		case ASSET_FRAME_MAP_THREE_TREES:
			return random_range(0.35, 0.55);
		case ASSET_FRAME_MAP_PALACE:
		case ASSET_FRAME_MAP_HOUSE:
		case ASSET_FRAME_MAP_HUT:
			return random_range(0.6, 0.85);
		case ASSET_FRAME_MAP_ROOF:
		case ASSET_FRAME_MAP_FIRE:
			return random_range(0.85, 1.0);
	}
	return 0.7;
}
