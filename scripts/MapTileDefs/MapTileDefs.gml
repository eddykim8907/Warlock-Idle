/// @description Tile template layouts (local coords within one MAP_TILE_SIZE chunk)
function map_tile_defs_get(_tile_id) {
	static _tiles = undefined;
	if (is_undefined(_tiles)) {
		_tiles = {
			forest: {
				ground_color: make_color_rgb(22, 38, 20),
				props: [
					{ frame: ASSET_FRAME_MAP_THREE_TREES, offset_x: 70, offset_y: 90, prop_scale: 4.5 },
					{ frame: ASSET_FRAME_MAP_TREE, offset_x: 220, offset_y: 60, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_TREE2, offset_x: 380, offset_y: 110, prop_scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_TREE, offset_x: 140, offset_y: 260, prop_scale: 3.8 },
					{ frame: ASSET_FRAME_MAP_TREE2, offset_x: 300, offset_y: 310, prop_scale: 4.4 },
					{ frame: ASSET_FRAME_MAP_TREE, offset_x: 420, offset_y: 400, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_THREE_TREES, offset_x: 80, offset_y: 390, prop_scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_TREE2, offset_x: 250, offset_y: 430, prop_scale: 3.9 },
				],
			},
			town: {
				ground_color: make_color_rgb(34, 30, 26),
				props: [
					{ frame: ASSET_FRAME_MAP_HOUSE, offset_x: 90, offset_y: 100, prop_scale: 5.0 },
					{ frame: ASSET_FRAME_MAP_HUT, offset_x: 280, offset_y: 140, prop_scale: 4.5 },
					{ frame: ASSET_FRAME_MAP_ROOF, offset_x: 390, offset_y: 90, prop_scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_FIRE, offset_x: 200, offset_y: 320, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_HOUSE, offset_x: 340, offset_y: 350, prop_scale: 4.8 },
					{ frame: ASSET_FRAME_MAP_HUT, offset_x: 110, offset_y: 380, prop_scale: 4.3 },
				],
			},
			landmark: {
				ground_color: make_color_rgb(30, 28, 34),
				props: [
					{ frame: ASSET_FRAME_MAP_PALACE, offset_x: 180, offset_y: 160, prop_scale: 5.5 },
					{ frame: ASSET_FRAME_MAP_TREE, offset_x: 60, offset_y: 120, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_TREE2, offset_x: 400, offset_y: 130, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_FIRE, offset_x: 100, offset_y: 380, prop_scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_FIRE, offset_x: 360, offset_y: 390, prop_scale: 4.0 },
				],
			},
		};
	}
	return _tiles[$ _tile_id];
}

function map_tile_defs_get_ground_color(_tile) {
	return struct_field(_tile, "ground_color", c_black);
}

function map_tile_defs_get_props(_tile) {
	return struct_field(_tile, "props", []);
}

function map_tile_prop_get_frame(_prop) {
	return struct_field(_prop, "frame", 0);
}

function map_tile_prop_get_offset_x(_prop) {
	return struct_field(_prop, "offset_x", 0);
}

function map_tile_prop_get_offset_y(_prop) {
	return struct_field(_prop, "offset_y", 0);
}

function map_tile_prop_get_scale(_prop) {
	return struct_field(_prop, "prop_scale", 1);
}

function map_tile_defs_all_ids() {
	return ["forest", "town", "landmark"];
}
