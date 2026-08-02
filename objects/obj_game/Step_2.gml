if (!game_manager_is_playing()) {
	exit;
}

var _player = instance_find(obj_player, 0);
if (_player != noone) {
	map_manager_update_chunks(_player.x, _player.y);
}
