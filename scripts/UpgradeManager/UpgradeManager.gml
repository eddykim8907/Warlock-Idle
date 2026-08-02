/// @description Upgrade purchase and leveling
function upgrade_manager_init() {
	global.upgrades = {
		catalog: upgrade_defs_init(),
		levels: {},
	};

	for (var i = 0; i < array_length(global.upgrades.catalog); i++) {
		var _id = global.upgrades.catalog[i].id;
		global.upgrades.levels[$ _id] = 0;
	}
}

function upgrade_manager_get_def(_upgrade_id) {
	for (var i = 0; i < array_length(global.upgrades.catalog); i++) {
		if (global.upgrades.catalog[i].id == _upgrade_id) {
			return global.upgrades.catalog[i];
		}
	}
	return undefined;
}

function upgrade_manager_get_level(_upgrade_id) {
	return global.upgrades.levels[$ _upgrade_id];
}

function upgrade_manager_get_cost(_upgrade_id) {
	var _def = upgrade_manager_get_def(_upgrade_id);
	var _level = upgrade_manager_get_level(_upgrade_id);
	return math_upgrade_cost(_def.base_cost, _def.cost_scale, _level);
}

function upgrade_manager_can_purchase(_upgrade_id) {
	var _def = upgrade_manager_get_def(_upgrade_id);
	if (is_undefined(_def)) return false;
	if (upgrade_manager_get_level(_upgrade_id) >= _def.max_level) return false;
	return economy_can_afford(upgrade_manager_get_cost(_upgrade_id));
}

function upgrade_manager_purchase(_upgrade_id) {
	var _def = upgrade_manager_get_def(_upgrade_id);
	if (is_undefined(_def)) return false;

	var _level = upgrade_manager_get_level(_upgrade_id);
	if (_level >= _def.max_level) return false;

	var _cost = upgrade_manager_get_cost(_upgrade_id);
	if (!economy_spend_gold(_cost)) return false;

	global.upgrades.levels[$ _upgrade_id]++;
	stat_manager_add_modifier(STAT_ENTITY_PLAYER, _def.stat, _def.op, _def.value, _upgrade_id);
	return true;
}

function upgrade_manager_get_catalog() {
	return global.upgrades.catalog;
}
