if (instance_number(obj_game) > 1) {
	instance_destroy();
	exit;
}

depth = 1000;

if (!variable_global_exists("game_initialized")) {
	game_manager_init();
	global.game_initialized = true;
} else {
	map_manager_ensure();
	dot_manager_ensure();
	upgrade_manager_ensure();
	if (!variable_global_exists("stats") || !variable_struct_exists(global.stats, "registry")) {
		stat_manager_init();
	}
}
