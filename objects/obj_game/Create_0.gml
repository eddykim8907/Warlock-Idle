if (instance_number(obj_game) > 1) {
	instance_destroy();
	exit;
}

depth = 1000;

if (!variable_global_exists("game_initialized")) {
	game_manager_init();
	global.game_initialized = true;
}
