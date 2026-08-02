/// @description Currency tracking
function economy_manager_init() {
	global.economy = {
		gold: 0,
		essence: 0,
		mega_essence: 0,
		infinite_gold: false,
	};
}

function economy_add_gold(_amount) {
	global.economy.gold += _amount;
}

function economy_add_essence(_amount) {
	global.economy.essence += _amount;
}

function economy_can_afford(_cost) {
	if (global.economy.infinite_gold) {
		return true;
	}
	return global.economy.gold >= _cost;
}

function economy_can_afford_essence(_cost) {
	return global.economy.essence >= _cost;
}

function economy_spend_gold(_cost) {
	if (global.economy.infinite_gold) {
		return true;
	}
	if (!economy_can_afford(_cost)) {
		return false;
	}
	global.economy.gold -= _cost;
	return true;
}

function economy_dev_toggle_infinite_gold() {
	global.economy.infinite_gold = !global.economy.infinite_gold;
	if (global.economy.infinite_gold) {
		global.economy.gold = 999999999;
	}
}

function economy_has_infinite_gold() {
	return global.economy.infinite_gold;
}

function economy_spend_essence(_cost) {
	if (!economy_can_afford_essence(_cost)) {
		return false;
	}
	global.economy.essence -= _cost;
	return true;
}

function economy_get_gold() {
	return global.economy.gold;
}

function economy_get_essence() {
	return global.economy.essence;
}
