/// @description Floating combat text registry
function combat_manager_init_damage_numbers() {
	global.damage_numbers = [];
}

function combat_manager_spawn_damage_number(_x, _y, _amount, _is_crit, _type) {
	array_push(global.damage_numbers, {
		draw_x: _x + random_range(-8, 8),
		draw_y: _y - 12,
		dmg_amount: max(1, round(_amount)),
		is_crit: _is_crit,
		dmg_type: _type,
		life: 0.9,
		vel_y: -48,
	});
}

function combat_manager_update_damage_numbers() {
	if (!variable_global_exists("damage_numbers")) {
		combat_manager_init_damage_numbers();
	}

	var _dt = global.time.delta;
	if (_dt <= 0) {
		_dt = delta_time / 1000000;
	}

	var _numbers = global.damage_numbers;
	for (var i = array_length(_numbers) - 1; i >= 0; i--) {
		var _n = _numbers[i];
		if (!struct_is_valid(_n, ["life", "draw_y", "vel_y"])) {
			array_delete(_numbers, i, 1);
			continue;
		}

		var _life = struct_field(_n, "life", 0) - _dt;
		var _draw_y = struct_field(_n, "draw_y", 0) + struct_field(_n, "vel_y", 0) * _dt;
		_n = {
			draw_x: struct_field(_n, "draw_x", 0),
			draw_y: _draw_y,
			dmg_amount: struct_field(_n, "dmg_amount", 0),
			is_crit: struct_field(_n, "is_crit", false),
			dmg_type: struct_field(_n, "dmg_type", "direct"),
			life: _life,
			vel_y: struct_field(_n, "vel_y", 0),
		};

		if (_life <= 0) {
			array_delete(_numbers, i, 1);
		} else {
			_numbers[i] = _n;
		}
	}
}

function combat_manager_draw_damage_numbers() {
	var _numbers = global.damage_numbers;
	for (var i = 0; i < array_length(_numbers); i++) {
		var _n = _numbers[i];
		if (!is_struct(_n)) {
			continue;
		}

		var _draw_x = struct_field(_n, "draw_x", 0);
		var _draw_y = struct_field(_n, "draw_y", 0);
		var _amount = struct_field(_n, "dmg_amount", 0);
		var _is_crit = struct_field(_n, "is_crit", false);
		var _dmg_type = struct_field(_n, "dmg_type", "direct");
		var _life = struct_field(_n, "life", 0);
		var _alpha = clamp(_life / 0.9, 0, 1);
		var _scale = _is_crit ? 1.25 : 1.0;

		draw_set_alpha(_alpha);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_black);
		draw_text_transformed(_draw_x + 1, _draw_y + 1, string(_amount), _scale, _scale, 0);
		draw_set_color(_is_crit ? c_yellow : (_dmg_type == "dot" ? make_color_rgb(255, 120, 80) : c_white));
		draw_text_transformed(_draw_x, _draw_y, string(_amount), _scale, _scale, 0);
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}

/// @description Direct and DoT damage handling
function combat_manager_apply_direct_damage(_source, _target, _base_amount, _tags) {
	if (!instance_exists(_target)) {
		return 0;
	}

	var _amount = _base_amount;
	var _is_crit = math_roll_crit(stat_manager_get(STAT_ENTITY_PLAYER, "crit_chance"));
	if (_is_crit) {
		_amount *= stat_manager_get(STAT_ENTITY_PLAYER, "crit_damage");
	}

	combat_manager_spawn_damage_number(_target.x, _target.y, _amount, _is_crit, "direct");

	_target.hp -= _amount;
	if (_target.hp <= 0) {
		combat_manager_on_enemy_killed(_target);
	}

	return _amount;
}

function combat_manager_apply_dot_damage(_dot_data) {
	var _target_id = struct_field(_dot_data, "target_id", noone);
	if (!instance_exists(_target_id)) {
		return 0;
	}

	var _target = _target_id;
	var _amount = struct_field(_dot_data, "damage_per_tick", 0) * struct_field(_dot_data, "stacks", 1);
	combat_manager_spawn_damage_number(_target.x, _target.y, _amount, false, "dot");
	_target.hp -= _amount;
	if (_target.hp <= 0) {
		combat_manager_on_enemy_killed(_target);
	}
	return _amount;
}

function combat_manager_on_enemy_killed(_enemy) {
	var _mult = stat_manager_get(STAT_ENTITY_PLAYER, "gold_drop_mult");
	economy_add_gold(floor(_enemy.gold_drop * _mult));

	if (variable_instance_exists(_enemy, "essence_drop") && _enemy.essence_drop > 0) {
		var _ess_mult = stat_manager_get(STAT_ENTITY_PLAYER, "essence_drop_mult");
		economy_add_essence(floor(_enemy.essence_drop * _ess_mult));
	}

	boss_manager_on_enemy_killed(_enemy);
	dot_manager_clear_target(_enemy.id);
	instance_destroy(_enemy);
}
