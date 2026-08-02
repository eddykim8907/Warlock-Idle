/// @description Scrolling map props — gives the idle arena a sense of movement
function map_manager_init() {
	global.map = {
		stage_index: 0,
		scroll_speed_x: 22,
		scroll_speed_y: 32,
		props: [],
	};

	repeat (70) {
		map_manager_spawn_prop(
			random_range(0, room_width),
			random_range(0, room_height)
		);
	}
}

function map_manager_ensure() {
	if (!variable_global_exists("map") || !is_array(global.map.props)) {
		map_manager_init();
		return;
	}
	if (array_length(global.map.props) == 0 || !variable_struct_exists(global.map.props[0], "x")) {
		map_manager_init();
	}
}

function map_manager_get_stage() {
	return global.map.stage_index;
}

function map_manager_advance_stage() {
	// Phase 3: gold ticket purchase
}

function map_manager_spawn_prop(_x, _y) {
	var _frame = asset_defs_pick_map_frame();
	var _parallax = asset_defs_map_parallax(_frame);
	var _scale = random_range(3.5, 5.5);
	if (_frame == ASSET_FRAME_MAP_PALACE) {
		_scale = random_range(4.5, 6.5);
	}

	array_push(global.map.props, {
		x: _x,
		y: _y,
		frame: _frame,
		parallax: _parallax,
		scale: _scale,
		phase: random(1000),
	});
}

function map_manager_step() {
	map_manager_ensure();
	if (!variable_global_exists("map")) {
		return;
	}

	var _dt = global.time.delta;
	if (_dt <= 0) {
		_dt = delta_time / 1000000;
	}

	var _props = global.map.props;
	var _margin = 64;
	for (var _i = 0; _i < array_length(_props); _i++) {
		var _p = _props[_i];
		_p.x -= global.map.scroll_speed_x * _p.parallax * _dt;
		_p.y -= global.map.scroll_speed_y * _p.parallax * _dt;

		while (_p.x < -_margin) {
			_p.x += room_width + _margin * 2;
		}
		while (_p.x > room_width + _margin) {
			_p.x -= room_width + _margin * 2;
		}

		if (_p.y < -_margin) {
			_p.y = room_height + random_range(16, 120);
			_p.x = random_range(0, room_width);
			_p.frame = asset_defs_pick_map_frame();
			_p.parallax = asset_defs_map_parallax(_p.frame);
			_p.scale = random_range(3.5, 5.5);
			if (_p.frame == ASSET_FRAME_MAP_PALACE) {
				_p.scale = random_range(4.5, 6.5);
			}
			_p.phase = random(1000);
		}

		_props[@ _i] = _p;
	}
}

function map_manager_draw() {
	map_manager_ensure();
	if (!variable_global_exists("map")) {
		return;
	}

	var _props = global.map.props;
	array_sort(_props, function(_a, _b) {
		return sign(_a.parallax - _b.parallax);
	});

	gpu_set_blendmode(bm_normal);
	for (var _i = 0; _i < array_length(_props); _i++) {
		var _p = _props[_i];
		var _alpha = 1;
		if (_p.frame == ASSET_FRAME_MAP_FIRE) {
			_alpha = 0.75 + sin(current_time / 180 + _p.phase) * 0.25;
		}

		draw_sprite_ext(
			ASSET_SPRITE,
			_p.frame,
			_p.x,
			_p.y,
			_p.scale,
			_p.scale,
			0,
			c_white,
			_alpha
		);
	}

	draw_set_alpha(1);
	draw_set_color(c_white);
}
