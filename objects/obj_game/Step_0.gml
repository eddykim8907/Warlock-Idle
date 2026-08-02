if (!game_manager_is_playing()) {
	exit;
}

time_manager_step();
spawn_manager_step();
