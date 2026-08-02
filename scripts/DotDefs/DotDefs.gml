/// @description DoT type registry
function dot_defs_init() {
	return {
		bleed: {
			duration_ticks: 50,
			max_stacks: 999,
			tick_damage_stat: "bleed_dpt",
			base_tick_damage: 2,
			on_apply: undefined,
			on_tick: undefined,
		},
		burn: {
			duration_ticks: 30,
			max_stacks: 1,
			tick_damage_stat: "burn_dpt",
			base_tick_damage: 3,
			on_apply: undefined,
			on_tick: dot_burn_on_tick,
		},
	};
}

function dot_defs_get_tick_damage(_def_id, _entity_id) {
	if (is_undefined(_entity_id)) {
		_entity_id = STAT_ENTITY_PLAYER;
	}

	var _def = global.dots.defs[$ _def_id];
	if (is_undefined(_def)) {
		return 1;
	}

	if (!is_undefined(struct_field(_def, "tick_damage_stat", undefined))) {
		return stat_manager_get(_entity_id, struct_field(_def, "tick_damage_stat", ""));
	}

	return struct_field(_def, "base_tick_damage", 1);
}

/// @description Burn spread hook placeholder
function dot_burn_on_tick(_dot_inst) {
	// Phase 3: chance to spread to random enemy
}
