/// @description Roll crit given chance 0..1
function math_roll_crit(_chance) {
	return random(1) < _chance;
}

/// @description Upgrade cost at current level
function math_upgrade_cost(_base, _scale, _level) {
	return floor(_base * power(_scale, _level));
}
