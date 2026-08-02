/// @description Map / stage configuration
function map_defs_get(_stage) {
	return {
		id: "stage_1",
		spawn_interval_base: 2.0,
		spawn_interval_min: 0.5,
		spawn_ramp_seconds: 120,
		max_enemies: 80,
		spawn_radius: 420,
		enemy_def_id: "grunt",
	};
}

/// @description Pick a tile template id for world chunk coordinates
function map_defs_pick_tile_type(_chunk_x, _chunk_y) {
	var _hash = abs(floor(sin(_chunk_x * 127.1 + _chunk_y * 311.7) * 43758.5453));
	var _roll = _hash mod 100;

	if (_roll < 55) {
		return "forest";
	}
	if (_roll < 88) {
		return "town";
	}
	return "landmark";
}
