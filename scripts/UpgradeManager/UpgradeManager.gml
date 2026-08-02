/// @description Upgrade purchase and leveling
function upgrade_manager_init() {
	global.upgrades = {
		catalog: upgrade_defs_init(),
		levels: {},
	};

	for (var i = 0; i < array_length(global.upgrades.catalog); i++) {
		var _entry = global.upgrades.catalog[i];
		global.upgrades.levels[$ upgrade_defs_get_key(_entry)] = 0;
	}
}

function upgrade_manager_ensure() {
	if (!variable_global_exists("upgrades") || !is_struct(global.upgrades)) {
		upgrade_manager_init();
		return;
	}

	if (!variable_struct_exists(global.upgrades, "catalog") || !is_array(global.upgrades.catalog)) {
		global.upgrades.catalog = upgrade_defs_init();
	}
	if (!variable_struct_exists(global.upgrades, "levels") || !is_struct(global.upgrades.levels)) {
		global.upgrades.levels = {};
	}
}

function upgrade_manager_get_def(_upgrade_id) {
	upgrade_manager_ensure();

	var _catalog = global.upgrades.catalog;
	for (var i = 0; i < array_length(_catalog); i++) {
		var _entry = _catalog[i];
		if (!is_struct(_entry)) {
			continue;
		}
		if (upgrade_defs_get_key(_entry) == _upgrade_id) {
			return _entry;
		}
	}
	return undefined;
}

function upgrade_manager_get_level(_upgrade_id) {
	upgrade_manager_ensure();
	return global.upgrades.levels[$ _upgrade_id];
}

function upgrade_manager_get_cost(_upgrade_id) {
	var _entry = upgrade_manager_get_def(_upgrade_id);
	var _level = upgrade_manager_get_level(_upgrade_id);
	return math_upgrade_cost(upgrade_defs_get_base_cost(_entry), upgrade_defs_get_cost_scale(_entry), _level);
}

function upgrade_manager_can_purchase(_upgrade_id) {
	var _entry = upgrade_manager_get_def(_upgrade_id);
	if (is_undefined(_entry)) {
		return false;
	}
	if (upgrade_manager_get_level(_upgrade_id) >= upgrade_defs_get_max_level(_entry)) {
		return false;
	}
	return economy_can_afford(upgrade_manager_get_cost(_upgrade_id));
}

function upgrade_manager_purchase(_upgrade_id) {
	var _entry = upgrade_manager_get_def(_upgrade_id);
	if (is_undefined(_entry)) {
		return false;
	}

	var _level = upgrade_manager_get_level(_upgrade_id);
	if (_level >= upgrade_defs_get_max_level(_entry)) {
		return false;
	}

	var _cost = upgrade_manager_get_cost(_upgrade_id);
	if (!economy_spend_gold(_cost)) {
		return false;
	}

	global.upgrades.levels[$ _upgrade_id]++;
	stat_manager_add_modifier(
		upgrade_defs_get_stat_entity(_entry),
		upgrade_defs_get_stat(_entry),
		upgrade_defs_get_op(_entry),
		upgrade_defs_get_value(_entry),
		_upgrade_id
	);
	return true;
}

function upgrade_manager_get_catalog() {
	upgrade_manager_ensure();
	return global.upgrades.catalog;
}
