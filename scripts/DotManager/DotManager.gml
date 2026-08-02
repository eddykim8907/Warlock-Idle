/// @description Active DoT instance registry
function dot_manager_init() {
	global.dots = {
		active: [],
		next_uid: 0,
		defs: dot_defs_init(),
	};
}

function dot_manager_ensure() {
	if (!variable_global_exists("dots") || !is_struct(global.dots)) {
		dot_manager_init();
		return;
	}

	if (!variable_struct_exists(global.dots, "active") || !is_array(global.dots.active)) {
		global.dots.active = [];
	}
	if (!variable_struct_exists(global.dots, "defs") || !is_struct(global.dots.defs)) {
		global.dots.defs = dot_defs_init();
	}
	if (!variable_struct_exists(global.dots, "next_uid")) {
		global.dots.next_uid = 0;
	}

	dot_manager_purge_invalid();
}

function dot_manager_purge_invalid() {
	var _list = global.dots.active;
	for (var i = array_length(_list) - 1; i >= 0; i--) {
		var _dot = _list[i];
		if (!is_struct(_dot) || !variable_struct_exists(_dot, "def_id") || !variable_struct_exists(_dot, "target_id")) {
			array_delete(_list, i, 1);
		}
	}
}

function dot_manager_apply(_def_id, _source, _target, _stacks, _stat_entity) {
	dot_manager_ensure();

	if (!instance_exists(_target)) {
		return undefined;
	}

	var _def = global.dots.defs[$ _def_id];
	if (is_undefined(_def)) {
		return undefined;
	}

	var _dot = {
		uid: global.dots.next_uid++,
		def_id: _def_id,
		source_id: _source,
		target_id: _target,
		damage_per_tick: dot_defs_get_tick_damage(_def_id, _stat_entity),
		ticks_remaining: struct_field(_def, "duration_ticks", 1),
		stacks: max(1, _stacks),
		metadata: {},
	};

	var _on_apply = struct_field(_def, "on_apply", undefined);
	if (!is_undefined(_on_apply) && is_method(_on_apply)) {
		_on_apply(_dot);
	}

	array_push(global.dots.active, _dot);
	return _dot.uid;
}

function dot_manager_tick() {
	dot_manager_ensure();

	var _list = global.dots.active;

	for (var i = array_length(_list) - 1; i >= 0; i--) {
		var _dot = _list[i];

		if (!is_struct(_dot) || !variable_struct_exists(_dot, "def_id")) {
			array_delete(_list, i, 1);
			continue;
		}

		var _def_id = struct_field(_dot, "def_id", "");
		var _target_id = struct_field(_dot, "target_id", noone);

		if (_def_id == "" || !instance_exists(_target_id)) {
			array_delete(_list, i, 1);
			continue;
		}

		var _def = global.dots.defs[$ _def_id];
		if (is_undefined(_def)) {
			array_delete(_list, i, 1);
			continue;
		}

		combat_manager_apply_dot_damage(_dot);

		var _on_tick = struct_field(_def, "on_tick", undefined);
		if (!is_undefined(_on_tick) && is_method(_on_tick)) {
			_on_tick(_dot);
		}

		var _ticks = struct_field(_dot, "ticks_remaining", 0) - 1;
		if (_ticks <= 0) {
			array_delete(_list, i, 1);
		} else {
			_list[i] = {
				uid: struct_field(_dot, "uid", 0),
				def_id: _def_id,
				source_id: struct_field(_dot, "source_id", noone),
				target_id: _target_id,
				damage_per_tick: struct_field(_dot, "damage_per_tick", 0),
				ticks_remaining: _ticks,
				stacks: struct_field(_dot, "stacks", 1),
				metadata: struct_field(_dot, "metadata", {}),
			};
		}
	}
}

function dot_manager_clear_target(_target_id) {
	dot_manager_ensure();

	var _list = global.dots.active;
	for (var i = array_length(_list) - 1; i >= 0; i--) {
		var _dot = _list[i];
		if (is_struct(_dot) && struct_field(_dot, "target_id", noone) == _target_id) {
			array_delete(_list, i, 1);
		}
	}
}

function dot_manager_remove(_dot_uid) {
	dot_manager_ensure();

	var _list = global.dots.active;
	for (var i = array_length(_list) - 1; i >= 0; i--) {
		var _dot = _list[i];
		if (is_struct(_dot) && struct_field(_dot, "uid", -1) == _dot_uid) {
			array_delete(_list, i, 1);
		}
	}
}

function dot_manager_get_active_count() {
	dot_manager_ensure();
	return array_length(global.dots.active);
}
