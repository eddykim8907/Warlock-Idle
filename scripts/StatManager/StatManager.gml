/// @description Base stats + modifier resolution
function stat_manager_init() {
	global.stats = {
		entities: {},
	};

	stat_manager_register_entity(STAT_ENTITY_PLAYER, {
		attack_damage: 10,
		attack_speed: 1.0,
		crit_chance: 0.05,
		crit_damage: 2.0,
		gold_drop_mult: 1.0,
	});
}

function stat_manager_register_entity(_entity_id, _base_stats) {
	global.stats.entities[$ _entity_id] = {
		base: _base_stats,
		modifiers: [],
	};
}

function stat_manager_add_modifier(_entity_id, _stat, _op, _value, _source) {
	var _ent = global.stats.entities[$ _entity_id];
	array_push(_ent.modifiers, {
		stat: _stat,
		op: _op,
		value: _value,
		source: _source,
	});
}

function stat_manager_get(_entity_id, _stat) {
	var _ent = global.stats.entities[$ _entity_id];
	var _val = _ent.base[$ _stat];
	if (is_undefined(_val)) {
		_val = 0;
	}

	var _add = 0;
	var _mult_sum = 0;

	for (var i = 0; i < array_length(_ent.modifiers); i++) {
		var _m = _ent.modifiers[i];
		if (_m.stat != _stat) continue;
		if (_m.op == "add") {
			_add += _m.value;
		} else if (_m.op == "mult") {
			_mult_sum += _m.value;
		}
	}

	return (_val + _add) * (1 + _mult_sum);
}
