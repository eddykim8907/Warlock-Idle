/// @description DoT type registry (stub hooks for Phase 2)
function dot_defs_init() {
	return {
		bleed: {
			id: "bleed",
			duration_ticks: 50,
			max_stacks: 999,
			on_apply: undefined,
			on_tick: undefined,
		},
		burn: {
			id: "burn",
			duration_ticks: 30,
			max_stacks: 1,
			on_apply: undefined,
			on_tick: undefined,
		},
	};
}

/// @description Burn spread hook placeholder
function dot_burn_on_tick(_dot_inst) {
	// Phase 2: chance to spread to random enemy
}
