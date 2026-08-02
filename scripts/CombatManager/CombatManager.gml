/// @description Direct and DoT damage handling
function combat_manager_apply_direct_damage(_source, _target, _base_amount, _tags) {
	if (!instance_exists(_target)) {
		return 0;
	}

	var _amount = _base_amount;
	if (math_roll_crit(stat_manager_get(STAT_ENTITY_PLAYER, "crit_chance"))) {
		_amount *= stat_manager_get(STAT_ENTITY_PLAYER, "crit_damage");
	}

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
