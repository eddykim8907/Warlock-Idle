/// @description Boss summon and lifecycle
function boss_manager_init() {
	global.boss = {
		active: noone,
		summon_cost: 100,
	};
}

function boss_manager_is_active() {
	return global.boss.active != noone && instance_exists(global.boss.active);
}

function boss_manager_can_summon() {
	if (boss_manager_is_active()) {
		return false;
	}
	return economy_can_afford(global.boss.summon_cost);
}

function boss_manager_summon() {
	if (!boss_manager_can_summon()) {
		return false;
	}

	if (!economy_spend_gold(global.boss.summon_cost)) {
		return false;
	}

	var _player = instance_find(obj_player, 0);
	if (_player == noone) {
		return false;
	}

	var _cfg = global.spawn.map_def;
	var _angle = random(360);
	var _dist = map_defs_get_spawn_radius(_cfg) * 0.75;
	var _ex = _player.x + lengthdir_x(_dist, _angle);
	var _ey = _player.y + lengthdir_y(_dist, _angle);
	var _enemy_def = enemy_defs_get("boss");

	var _boss = instance_create_layer(_ex, _ey, "Instances", obj_enemy);
	_boss.enemy_def_id = "boss";
	_boss.is_boss = true;
	_boss.hp = enemy_defs_get_base_hp(_enemy_def);
	_boss.hp_max = enemy_defs_get_base_hp(_enemy_def);
	_boss.move_speed = enemy_defs_get_base_speed(_enemy_def);
	_boss.gold_drop = enemy_defs_get_gold_drop(_enemy_def);
	_boss.essence_drop = enemy_defs_get_essence_drop(_enemy_def);
	_boss.sprite_frame = enemy_defs_get_sprite_frame(_enemy_def);
	_boss.image_index = enemy_defs_get_sprite_frame(_enemy_def);
	_boss.image_xscale = enemy_defs_get_draw_scale(_enemy_def);
	_boss.image_yscale = enemy_defs_get_draw_scale(_enemy_def);
	_boss.image_blend = make_color_rgb(210, 150, 255);
	_boss.depth = -10;

	global.boss.active = _boss.id;
	return true;
}

function boss_manager_on_enemy_killed(_enemy) {
	if (!variable_instance_exists(_enemy, "is_boss") || !_enemy.is_boss) {
		return;
	}

	if (global.boss.active == _enemy.id) {
		global.boss.active = noone;
	}
}

function boss_manager_on_player_death() {
	if (!boss_manager_is_active()) {
		return;
	}

	instance_destroy(global.boss.active);
	global.boss.active = noone;
}
