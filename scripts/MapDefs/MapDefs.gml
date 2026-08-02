/// @description Map / stage configuration
function map_defs_get(_stage) {
	return {
		id: "stage_1",
		spawn_interval_base: 2.0,
		spawn_interval_min: 0.5,
		spawn_ramp_seconds: 120,
		max_enemies: 80,
		spawn_radius: 400,
		enemy_def_id: "grunt",
	};
}
