/// @description Active DoT instance registry
function dot_manager_init() {
	global.dots = {
		instances: [],
		next_id: 0,
		defs: dot_defs_init(),
	};
}

function dot_manager_apply(_def_id, _source, _target, _stacks) {
	if (!instance_exists(_target)) {
		return undefined;
	}

	var _def = global.dots.defs[$ _def_id];
	if (is_undefined(_def)) {
		return undefined;
	}

	var _inst = {
		id: global.dots.next_id++,
		def_id: _def_id,
		source_id: _source,
		target_id: _target,
		damage_per_tick: 1,
		ticks_remaining: _def.duration_ticks,
		stacks: max(1, _stacks),
		metadata: {},
	};

	if (!is_undefined(_def.on_apply) && is_method(_def.on_apply)) {
		_def.on_apply(_inst);
	}

	array_push(global.dots.instances, _inst);
	return _inst.id;
}

function dot_manager_tick() {
	var _inst_list = global.dots.instances;

	for (var i = array_length(_inst_list) - 1; i >= 0; i--) {
		var _dot = _inst_list[i];
		var _def = global.dots.defs[$ _dot.def_id];

		if (!instance_exists(_dot.target_id)) {
			array_delete(_inst_list, i, 1);
			continue;
		}

		combat_manager_apply_dot_damage(_dot);

		if (!is_undefined(_def.on_tick) && is_method(_def.on_tick)) {
			_def.on_tick(_dot);
		}

		_dot.ticks_remaining--;
		if (_dot.ticks_remaining <= 0) {
			array_delete(_inst_list, i, 1);
		} else {
			_inst_list[i] = _dot;
		}
	}
}

function dot_manager_clear_target(_target_id) {
	var _inst_list = global.dots.instances;
	for (var i = array_length(_inst_list) - 1; i >= 0; i--) {
		if (_inst_list[i].target_id == _target_id) {
			array_delete(_inst_list, i, 1);
		}
	}
}

function dot_manager_remove(_dot_id) {
	var _inst_list = global.dots.instances;
	for (var i = array_length(_inst_list) - 1; i >= 0; i--) {
		if (_inst_list[i].id == _dot_id) {
			array_delete(_inst_list, i, 1);
		}
	}
}
