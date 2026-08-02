var _dt = global.time.delta;
if (_dt <= 0) {
	_dt = delta_time / 1000000;
}

var _player = instance_find(obj_player, 0);
if (_player == noone) {
	exit;
}

var _entry = totem_defs_get(totem_type);
orbit_angle += 20 * _dt;
x = _player.x + lengthdir_x(orbit_radius, orbit_angle + orbit_offset);
y = _player.y + lengthdir_y(orbit_radius, orbit_angle + orbit_offset);

fire_cooldown -= _dt;
if (fire_cooldown > 0) {
	exit;
}

var _target = totem_manager_find_target(x, y, totem_defs_get_attack_range(_entry));
if (_target == noone) {
	exit;
}

fire_cooldown = totem_defs_get_fire_interval(_entry);
dot_manager_apply(
	totem_defs_get_dot_id(_entry),
	id,
	_target,
	totem_defs_get_stacks_per_hit(_entry),
	totem_defs_get_stat_entity(_entry)
);
