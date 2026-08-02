/// @description Totem placement and combat helpers
function totem_manager_init() {
	global.totems = {
		active: [],
		counts: {},
	};

	var _ids = totem_defs_get_all_ids();
	for (var i = 0; i < array_length(_ids); i++) {
		global.totems.counts[$ _ids[i]] = 0;
	}
}

function totem_manager_get_count(_type_id) {
	if (!variable_struct_exists(global.totems.counts, _type_id)) {
		return 0;
	}
	return global.totems.counts[$ _type_id];
}

function totem_manager_can_purchase(_type_id) {
	var _entry = totem_defs_get(_type_id);
	if (is_undefined(_entry)) {
		return false;
	}
	if (totem_manager_get_count(_type_id) >= totem_defs_get_max_count(_entry)) {
		return false;
	}
	return economy_can_afford(totem_defs_get_placement_cost_gold(_entry));
}

function totem_manager_try_purchase(_type_id) {
	if (!totem_manager_can_purchase(_type_id)) {
		return false;
	}

	var _entry = totem_defs_get(_type_id);
	if (!economy_spend_gold(totem_defs_get_placement_cost_gold(_entry))) {
		return false;
	}

	totem_manager_place(_type_id);
	return true;
}

function totem_manager_place(_type_id) {
	var _player = instance_find(obj_player, 0);
	if (_player == noone) {
		return noone;
	}

	var _entry = totem_defs_get(_type_id);
	var _slot = totem_manager_get_count(_type_id);
	var _totem = instance_create_layer(_player.x, _player.y, "Instances", obj_totem);
	_totem.totem_type = _type_id;
	_totem.orbit_offset = (_slot / max(totem_defs_get_max_count(_entry), 1)) * 360;
	_totem.orbit_radius = totem_defs_get_orbit_radius(_entry) + (_slot mod 2) * 18;
	_totem.orbit_angle = _totem.orbit_offset;
	_totem.fire_cooldown = random(totem_defs_get_fire_interval(_entry));

	global.totems.counts[$ _type_id]++;
	array_push(global.totems.active, _totem.id);
	return _totem.id;
}

function totem_manager_find_target(_world_x, _world_y, _range) {
	var _nearest = noone;
	var _nearest_dist = _range;

	with (obj_enemy) {
		var _dist = point_distance(_world_x, _world_y, x, y);
		if (_dist <= _nearest_dist) {
			_nearest = id;
			_nearest_dist = _dist;
		}
	}

	return _nearest;
}

function totem_manager_on_destroyed(_inst) {
	var _type_id = _inst.totem_type;
	if (variable_struct_exists(global.totems.counts, _type_id)) {
		global.totems.counts[$ _type_id] = max(0, global.totems.counts[$ _type_id] - 1);
	}

	var _active = global.totems.active;
	for (var i = array_length(_active) - 1; i >= 0; i--) {
		if (_active[i] == _inst.id) {
			array_delete(_active, i, 1);
		}
	}
}

function totem_manager_get_active_dot_count() {
	return dot_manager_get_active_count();
}
