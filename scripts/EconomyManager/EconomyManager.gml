/// @description Currency tracking
function economy_manager_init() {
	global.economy = {
		gold: 0,
		essence: 0,
		mega_essence: 0,
	};
}

function economy_add_gold(_amount) {
	global.economy.gold += _amount;
}

function economy_can_afford(_cost) {
	return global.economy.gold >= _cost;
}

function economy_spend_gold(_cost) {
	if (!economy_can_afford(_cost)) {
		return false;
	}
	global.economy.gold -= _cost;
	return true;
}

function economy_get_gold() {
	return global.economy.gold;
}
