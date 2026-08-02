/// @description Enemy wave spawning around the player
function spawn_manager_init() {
	global.spawn = {
		map_def: map_defs_get(0),
		timer: 0,
	};
}

function spawn_manager_step() {
	var _def = global.spawn.map_def;
	if (instance_number(obj_enemy) >= _def.max_enemies) {
		return;
	}

	global.spawn.timer -= global.time.delta;
	if (global.spawn.timer > 0) {
		return;
	}

	var _t_norm = clamp(global.time.elapsed / _def.spawn_ramp_seconds, 0, 1);
	var _interval = lerp(_def.spawn_interval_base, _def.spawn_interval_min, _t_norm);
	global.spawn.timer = _interval;

	var _player = instance_find(obj_player, 0);
	if (_player == noone) {
		return;
	}

	var _angle = random(360);
	var _ex = _player.x + lengthdir_x(_def.spawn_radius, _angle);
	var _ey = _player.y + lengthdir_y(_def.spawn_radius, _angle);
	var _enemy_def = enemy_defs_get(_def.enemy_def_id);

	var _enemy = instance_create_layer(_ex, _ey, "Instances", obj_enemy);
	_enemy.enemy_def_id = _def.enemy_def_id;
	_enemy.hp = _enemy_def.hp;
	_enemy.hp_max = _enemy_def.hp;
	_enemy.move_speed = _enemy_def.speed;
	_enemy.gold_drop = _enemy_def.gold_drop;
	_enemy.sprite_frame = _enemy_def.sprite_frame;
	_enemy.image_index = _enemy_def.sprite_frame;
}
