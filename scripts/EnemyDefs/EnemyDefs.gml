/// @description Enemy stat definitions by id
function enemy_defs_get(_enemy_id) {
	static _defs = undefined;
	if (is_undefined(_defs)) {
		_defs = {
			grunt: {
				base_hp: 20,
				base_speed: 1.2,
				gold_drop: 3,
				essence_drop: 0,
				sprite_frame: ASSET_FRAME_STAGE_1_MOB,
				draw_scale: 3,
			},
			boss: {
				base_hp: 600,
				base_speed: 0.85,
				gold_drop: 25,
				essence_drop: 50,
				sprite_frame: ASSET_FRAME_STAGE_1_MOB,
				draw_scale: 5,
			},
		};
	}
	return _defs[$ _enemy_id];
}

function enemy_defs_get_base_hp(_entry) {
	return struct_field(_entry, "base_hp", 1);
}

function enemy_defs_get_base_speed(_entry) {
	return struct_field(_entry, "base_speed", 1);
}

function enemy_defs_get_gold_drop(_entry) {
	return struct_field(_entry, "gold_drop", 0);
}

function enemy_defs_get_essence_drop(_entry) {
	return struct_field(_entry, "essence_drop", 0);
}

function enemy_defs_get_sprite_frame(_entry) {
	return struct_field(_entry, "sprite_frame", 0);
}

function enemy_defs_get_draw_scale(_entry) {
	return struct_field(_entry, "draw_scale", 1);
}
