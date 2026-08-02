/// @description Enemy stat definitions by id
function enemy_defs_get(_enemy_id) {
	static _defs = undefined;
	if (is_undefined(_defs)) {
		_defs = {
			grunt: {
				id: "grunt",
				hp: 20,
				speed: 1.2,
				gold_drop: 3,
				sprite_frame: 10,
			},
		};
	}
	return _defs[$ _enemy_id];
}
