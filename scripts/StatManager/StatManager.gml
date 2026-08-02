/// @description Base stats + modifier resolution
function stat_manager_init() {
	global.stats = {
		registry: {},
	};

	stat_manager_register_entity(STAT_ENTITY_PLAYER, {
		attack_damage: 10,
		attack_speed: 1.0,
		crit_chance: 0.05,
		crit_damage: 2.0,
		gold_drop_mult: 1.0,
		essence_drop_mult: 1.0,
	});

	stat_manager_register_entity(STAT_ENTITY_TOTEM_BLEED, {
		bleed_dpt: 3,
	});
}

function stat_manager_register_entity(_entity_id, _base_stats) {
	global.stats.registry[$ _entity_id] = {
		base: _base_stats,
		modifiers: [],
	};
}

function stat_manager_add_modifier(_entity_id, _stat, _op, _value, _source) {
	var _ent = global.stats.registry[$ _entity_id];
	array_push(_ent.modifiers, {
		stat_key: _stat,
		op_kind: _op,
		mod_value: _value,
		mod_source: _source,
	});
}

function stat_manager_get(_entity_id, _stat) {
	if (!variable_global_exists("stats") || !variable_struct_exists(global.stats, "registry")) {
		stat_manager_init();
	}

	var _ent = global.stats.registry[$ _entity_id];
	var _val = _ent.base[$ _stat];
	if (is_undefined(_val)) {
		_val = 0;
	}

	var _add = 0;
	var _mult_sum = 0;

	for (var i = 0; i < array_length(_ent.modifiers); i++) {
		var _m = _ent.modifiers[i];
		if (struct_field(_m, "stat_key", "") != _stat) {
			continue;
		}
		if (struct_field(_m, "op_kind", "") == "add") {
			_add += struct_field(_m, "mod_value", 0);
		} else if (struct_field(_m, "op_kind", "") == "mult") {
			_mult_sum += struct_field(_m, "mod_value", 0);
		}
	}

	return (_val + _add) * (1 + _mult_sum);
}
