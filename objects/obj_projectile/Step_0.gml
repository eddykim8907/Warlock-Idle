var _next_x = x + lengthdir_x(move_speed, direction);
var _next_y = y + lengthdir_y(move_speed, direction);

// collision_line/circle work without a sprite mask on this object (instance_place does not)
var _hit = collision_line(x, y, _next_x, _next_y, obj_enemy, false, true);
if (_hit == noone) {
	_hit = collision_circle(_next_x, _next_y, 14, obj_enemy, false, true);
}

if (_hit != noone) {
	combat_manager_apply_direct_damage(owner, _hit, damage, []);
	instance_destroy();
	exit;
}

x = _next_x;
y = _next_y;

if (x < -32 || x > room_width + 32 || y < -32 || y > room_height + 32) {
	instance_destroy();
}
