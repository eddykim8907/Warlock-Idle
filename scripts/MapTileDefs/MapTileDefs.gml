/// @description Tile template layouts (local coords within one MAP_TILE_SIZE chunk)
function map_tile_defs_get(_tile_id) {
	static _tiles = undefined;
	if (is_undefined(_tiles)) {
		_tiles = {
			forest: {
				id: "forest",
				ground_color: make_color_rgb(22, 38, 20),
				props: [
					{ frame: ASSET_FRAME_MAP_THREE_TREES, x: 70, y: 90, scale: 4.5 },
					{ frame: ASSET_FRAME_MAP_TREE, x: 220, y: 60, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_TREE2, x: 380, y: 110, scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_TREE, x: 140, y: 260, scale: 3.8 },
					{ frame: ASSET_FRAME_MAP_TREE2, x: 300, y: 310, scale: 4.4 },
					{ frame: ASSET_FRAME_MAP_TREE, x: 420, y: 400, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_THREE_TREES, x: 80, y: 390, scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_TREE2, x: 250, y: 430, scale: 3.9 },
				],
			},
			town: {
				id: "town",
				ground_color: make_color_rgb(34, 30, 26),
				props: [
					{ frame: ASSET_FRAME_MAP_HOUSE, x: 90, y: 100, scale: 5.0 },
					{ frame: ASSET_FRAME_MAP_HUT, x: 280, y: 140, scale: 4.5 },
					{ frame: ASSET_FRAME_MAP_ROOF, x: 390, y: 90, scale: 4.2 },
					{ frame: ASSET_FRAME_MAP_FIRE, x: 200, y: 320, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_HOUSE, x: 340, y: 350, scale: 4.8 },
					{ frame: ASSET_FRAME_MAP_HUT, x: 110, y: 380, scale: 4.3 },
				],
			},
			landmark: {
				id: "landmark",
				ground_color: make_color_rgb(30, 28, 34),
				props: [
					{ frame: ASSET_FRAME_MAP_PALACE, x: 180, y: 160, scale: 5.5 },
					{ frame: ASSET_FRAME_MAP_TREE, x: 60, y: 120, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_TREE2, x: 400, y: 130, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_FIRE, x: 100, y: 380, scale: 4.0 },
					{ frame: ASSET_FRAME_MAP_FIRE, x: 360, y: 390, scale: 4.0 },
				],
			},
		};
	}
	return _tiles[$ _tile_id];
}

function map_tile_defs_all_ids() {
	return ["forest", "town", "landmark"];
}
