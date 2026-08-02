/// @description MVP upgrade catalog
function upgrade_defs_init() {
	return [
		{
			key: "wand_damage",
			stat_entity: STAT_ENTITY_PLAYER,
			stat_key: "attack_damage",
			op_kind: "mult",
			mod_value: 0.10,
			base_cost: 10,
			cost_scale: 1.15,
			max_level: 999,
			label: "Wand Damage",
		},
		{
			key: "wand_atk_spd",
			stat_entity: STAT_ENTITY_PLAYER,
			stat_key: "attack_speed",
			op_kind: "mult",
			mod_value: 0.05,
			base_cost: 15,
			cost_scale: 1.18,
			max_level: 999,
			label: "Attack Speed",
		},
		{
			key: "bleed_damage",
			stat_entity: STAT_ENTITY_TOTEM_BLEED,
			stat_key: "bleed_dpt",
			op_kind: "mult",
			mod_value: 0.12,
			base_cost: 20,
			cost_scale: 1.2,
			max_level: 999,
			label: "Bleed Damage",
		},
	];
}

function upgrade_defs_get_key(_entry) {
	return struct_field(_entry, "key", "");
}

function upgrade_defs_get_label(_entry) {
	return struct_field(_entry, "label", "");
}

function upgrade_defs_get_stat_entity(_entry) {
	return struct_field(_entry, "stat_entity", STAT_ENTITY_PLAYER);
}

function upgrade_defs_get_stat(_entry) {
	return struct_field(_entry, "stat_key", "");
}

function upgrade_defs_get_op(_entry) {
	return struct_field(_entry, "op_kind", "add");
}

function upgrade_defs_get_value(_entry) {
	return struct_field(_entry, "mod_value", 0);
}

function upgrade_defs_get_base_cost(_entry) {
	return struct_field(_entry, "base_cost", 0);
}

function upgrade_defs_get_cost_scale(_entry) {
	return struct_field(_entry, "cost_scale", 1);
}

function upgrade_defs_get_max_level(_entry) {
	return struct_field(_entry, "max_level", 1);
}
