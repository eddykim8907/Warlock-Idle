var _dt = global.time.delta;
if (_dt <= 0) {
	_dt = delta_time / 1000000;
}

// Always wander
move_dir += random_range(-move_turn_rate, move_turn_rate) * _dt;
var _move_x = lengthdir_x(1, move_dir);
var _move_y = lengthdir_y(1, move_dir);

// Blend in flee from nearby enemies
with (obj_enemy) {
	var _dist = point_distance(other.x, other.y, x, y);
	if (_dist > 0 && _dist < other.flee_radius) {
		var _weight = 1 - (_dist / other.flee_radius);
		var _away = point_direction(x, y, other.x, other.y);
		_move_x += lengthdir_x(_weight * 2, _away);
		_move_y += lengthdir_y(_weight * 2, _away);
	}
}

var _final_dir = point_direction(0, 0, _move_x, _move_y);
x += lengthdir_x(move_speed, _final_dir);
y += lengthdir_y(move_speed, _final_dir);

// Camera must update in Step (after movement), not Draw — same frame as position change
map_manager_update_camera(id);

fire_cooldown -= _dt;
if (fire_cooldown > 0) {
	exit;
}

var _target = instance_nearest(x, y, obj_enemy);
if (_target == noone) {
	exit;
}

var _attack_speed = stat_manager_get(STAT_ENTITY_PLAYER, "attack_speed");
fire_cooldown = 1 / max(_attack_speed, 0.1);

var _proj = instance_create_layer(x, y, "Instances", obj_projectile);
_proj.direction = point_direction(x, y, _target.x, _target.y);
_proj.damage = stat_manager_get(STAT_ENTITY_PLAYER, "attack_damage");
_proj.owner = id;
