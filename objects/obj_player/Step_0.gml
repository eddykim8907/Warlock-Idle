x = room_width * 0.5;
y = room_height * 0.5;

var _dt = global.time.delta;
if (_dt <= 0) {
	_dt = delta_time / 1000000;
}

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
