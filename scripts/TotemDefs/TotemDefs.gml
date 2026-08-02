/// @description Totem type registry
function totem_defs_get(_type_id) {
	static _defs = undefined;
	if (is_undefined(_defs)) {
		_defs = {
			bleed: {
				label: "Bleed Totem",
				dot_id: "bleed",
				stat_entity: STAT_ENTITY_TOTEM_BLEED,
				fire_interval: 1.1,
				attack_range: 300,
				stacks_per_hit: 1,
				sprite_frame: ASSET_FRAME_MAP_FIRE,
				sprite_scale: 3.5,
				orbit_radius: 90,
				placement_cost_gold: 50,
				max_count: 6,
			},
		};
	}
	return _defs[$ _type_id];
}

function totem_defs_get_all_ids() {
	return ["bleed"];
}

function totem_defs_get_label(_entry) {
	return struct_field(_entry, "label", "Totem");
}

function totem_defs_get_dot_id(_entry) {
	return struct_field(_entry, "dot_id", "bleed");
}

function totem_defs_get_stat_entity(_entry) {
	return struct_field(_entry, "stat_entity", STAT_ENTITY_TOTEM_BLEED);
}

function totem_defs_get_fire_interval(_entry) {
	return struct_field(_entry, "fire_interval", 1);
}

function totem_defs_get_attack_range(_entry) {
	return struct_field(_entry, "attack_range", 200);
}

function totem_defs_get_stacks_per_hit(_entry) {
	return struct_field(_entry, "stacks_per_hit", 1);
}

function totem_defs_get_sprite_frame(_entry) {
	return struct_field(_entry, "sprite_frame", 0);
}

function totem_defs_get_sprite_scale(_entry) {
	return struct_field(_entry, "sprite_scale", 1);
}

function totem_defs_get_orbit_radius(_entry) {
	return struct_field(_entry, "orbit_radius", 80);
}

function totem_defs_get_placement_cost_gold(_entry) {
	return struct_field(_entry, "placement_cost_gold", 50);
}

function totem_defs_get_max_count(_entry) {
	return struct_field(_entry, "max_count", 1);
}
