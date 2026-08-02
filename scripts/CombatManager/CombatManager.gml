/// @description Floating combat text registry
function combat_manager_init_damage_numbers() {
	global.damage_numbers = [];
}

function combat_manager_spawn_damage_number(_x, _y, _amount, _is_crit, _type) {
	array_push(global.damage_numbers, {
		x: _x + random_range(-8, 8),
		y: _y - 12,
		amount: max(1, round(_amount)),
		is_crit: _is_crit,
		type: _type,
		life: 0.9,
		vy: -48,
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
		_n.life -= _dt;
		_n.y += _n.vy * _dt;
		if (_n.life <= 0) {
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
		var _alpha = clamp(_n.life / 0.9, 0, 1);
		var _scale = _n.is_crit ? 1.25 : 1.0;

		draw_set_alpha(_alpha);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_set_color(c_black);
		draw_text_transformed(_n.x + 1, _n.y + 1, string(_n.amount), _scale, _scale, 0);
		draw_set_color(_n.is_crit ? c_yellow : c_white);
		draw_text_transformed(_n.x, _n.y, string(_n.amount), _scale, _scale, 0);
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

function combat_manager_apply_dot_damage(_dot_inst) {
	if (!instance_exists(_dot_inst.target_id)) {
		return 0;
	}

	var _target = _dot_inst.target_id;
	var _amount = _dot_inst.damage_per_tick * _dot_inst.stacks;
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
	dot_manager_clear_target(_enemy.id);
	instance_destroy(_enemy);
}
