/// @description Enemy wave spawning around the player
function spawn_manager_init() {
	global.spawn = {
		map_def: map_defs_get(0),
		timer: 0,
	};
}

function spawn_manager_step() {
	var _cfg = global.spawn.map_def;
	if (instance_number(obj_enemy) >= map_defs_get_max_enemies(_cfg)) {
		return;
	}

	global.spawn.timer -= global.time.delta;
	if (global.spawn.timer > 0) {
		return;
	}

	var _t_norm = clamp(global.time.elapsed / map_defs_get_spawn_ramp_seconds(_cfg), 0, 1);
	var _interval = lerp(map_defs_get_spawn_interval_base(_cfg), map_defs_get_spawn_interval_min(_cfg), _t_norm);
	global.spawn.timer = _interval;

	var _player = instance_find(obj_player, 0);
	if (_player == noone) {
		return;
	}

	var _angle = random(360);
	var _radius = map_defs_get_spawn_radius(_cfg);
	var _ex = _player.x + lengthdir_x(_radius, _angle);
	var _ey = _player.y + lengthdir_y(_radius, _angle);
	var _enemy_def = enemy_defs_get(map_defs_get_enemy_def_id(_cfg));

	var _enemy = instance_create_layer(_ex, _ey, "Instances", obj_enemy);
	_enemy.enemy_def_id = map_defs_get_enemy_def_id(_cfg);
	_enemy.hp = enemy_defs_get_base_hp(_enemy_def);
	_enemy.hp_max = enemy_defs_get_base_hp(_enemy_def);
	_enemy.move_speed = enemy_defs_get_base_speed(_enemy_def);
	_enemy.gold_drop = enemy_defs_get_gold_drop(_enemy_def);
	_enemy.essence_drop = enemy_defs_get_essence_drop(_enemy_def);
	_enemy.sprite_frame = enemy_defs_get_sprite_frame(_enemy_def);
	_enemy.image_index = enemy_defs_get_sprite_frame(_enemy_def);
	_enemy.image_xscale = enemy_defs_get_draw_scale(_enemy_def);
	_enemy.image_yscale = enemy_defs_get_draw_scale(_enemy_def);
	_enemy.is_boss = false;
}
