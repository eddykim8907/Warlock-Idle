/// @description Fixed-tick time service
function time_manager_init() {
	global.time = {
		delta: 0,
		game_speed: 1,
		elapsed: 0,
		tick_accum: 0,
		tick_count: 0,
	};
}

function time_manager_step() {
	global.time.delta = delta_time / 1000000 * global.time.game_speed;
	global.time.elapsed += global.time.delta;
	global.time.tick_accum += global.time.delta;

	while (global.time.tick_accum >= TICK_INTERVAL) {
		global.time.tick_accum -= TICK_INTERVAL;
		global.time.tick_count++;
		dot_manager_tick();
	}
}
