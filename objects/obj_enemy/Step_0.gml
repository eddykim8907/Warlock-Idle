var _player = instance_find(obj_player, 0);
if (_player == noone) {
	exit;
}

var _dir = point_direction(x, y, _player.x, _player.y);
x += lengthdir_x(move_speed, _dir);
y += lengthdir_y(move_speed, _dir);

image_index = sprite_frame;
