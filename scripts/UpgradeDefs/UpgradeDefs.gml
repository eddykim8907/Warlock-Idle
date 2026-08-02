/// @description MVP upgrade catalog
function upgrade_defs_init() {
	return [
		{
			id: "wand_damage",
			stat: "attack_damage",
			op: "mult",
			value: 0.10,
			base_cost: 10,
			cost_scale: 1.15,
			max_level: 999,
			label: "Wand Damage",
		},
		{
			id: "wand_atk_spd",
			stat: "attack_speed",
			op: "mult",
			value: 0.05,
			base_cost: 15,
			cost_scale: 1.18,
			max_level: 999,
			label: "Attack Speed",
		},
	];
}
