/// @description Chunked world map — fixed props in tile templates, load/unload by view
function map_manager_init() {
	var _existing_cam = -1;
	if (variable_global_exists("map")) {
		_existing_cam = global.map.camera_id;
		if (ds_exists(global.map.loaded_chunks, ds_type_map)) {
			ds_map_destroy(global.map.loaded_chunks);
		}
	}

	global.map = {
		stage_index: 0,
		loaded_chunks: ds_map_create(),
		camera_id: _existing_cam,
	};

	with (obj_map_prop) {
		instance_destroy();
	}

	map_manager_init_camera();
}

function map_manager_get_player_focus(_player) {
	return {
		focus_x: _player.x + sprite_get_width(_player.sprite_index) * _player.image_xscale * 0.5,
		focus_y: _player.y + sprite_get_height(_player.sprite_index) * _player.image_yscale * 0.5,
	};
}

function map_manager_init_camera() {
	view_visible[0] = true;
	view_wview[0] = VIEW_WIDTH;
	view_hview[0] = VIEW_HEIGHT;
	view_wport[0] = VIEW_WIDTH;
	view_hport[0] = VIEW_HEIGHT;
	view_xport[0] = 0;
	view_yport[0] = 0;
	view_hborder[0] = 0;
	view_vborder[0] = 0;

	if (!variable_global_exists("map")) {
		return;
	}

	if (global.map.camera_id == -1) {
		// No built-in object follow — position is set manually each step
		global.map.camera_id = camera_create_view(
			0,
			0,
			VIEW_WIDTH,
			VIEW_HEIGHT,
			0,
			-1,
			-1,
			-1,
			0,
			0,
			-1
		);
	}

	view_camera[0] = global.map.camera_id;
	camera_set_view_target(global.map.camera_id, -1);
	camera_set_view_speed(global.map.camera_id, -1, -1);
	camera_set_view_border(global.map.camera_id, 0, 0);

	var _player = instance_find(obj_player, 0);
	if (_player != noone) {
		map_manager_update_camera(_player);
	}
}

function map_manager_update_camera(_player) {
	if (_player == noone) {
		_player = instance_find(obj_player, 0);
	}
	if (_player == noone || !variable_global_exists("map")) {
		return;
	}

	if (global.map.camera_id == -1) {
		map_manager_init_camera();
	}
	if (global.map.camera_id == -1) {
		return;
	}

	var _focus = map_manager_get_player_focus(_player);
	var _cam_x = round(struct_field(_focus, "focus_x", _player.x) - VIEW_WIDTH * 0.5);
	var _cam_y = round(struct_field(_focus, "focus_y", _player.y) - VIEW_HEIGHT * 0.5);

	view_camera[0] = global.map.camera_id;
	camera_set_view_pos(global.map.camera_id, _cam_x, _cam_y);
}

function map_manager_get_view_bounds(_expand) {
	if (is_undefined(_expand)) {
		_expand = 0;
	}

	var _view_x = 0;
	var _view_y = 0;
	var _view_w = VIEW_WIDTH;
	var _view_h = VIEW_HEIGHT;

	if (variable_global_exists("map") && global.map.camera_id != -1) {
		_view_x = camera_get_view_x(global.map.camera_id);
		_view_y = camera_get_view_y(global.map.camera_id);
		_view_w = camera_get_view_width(global.map.camera_id);
		_view_h = camera_get_view_height(global.map.camera_id);
	}

	return {
		left: _view_x - _expand,
		top: _view_y - _expand,
		right: _view_x + _view_w + _expand,
		bottom: _view_y + _view_h + _expand,
	};
}

function map_manager_get_required_chunk_radius() {
	return ceil(max(VIEW_WIDTH, VIEW_HEIGHT) / MAP_TILE_SIZE) + MAP_CHUNK_MARGIN;
}

function map_manager_chunk_key(_chunk_x, _chunk_y) {
	return string(_chunk_x) + "," + string(_chunk_y);
}

function map_manager_world_to_chunk(_world_x, _world_y) {
	return {
		chunk_x: floor(_world_x / MAP_TILE_SIZE),
		chunk_y: floor(_world_y / MAP_TILE_SIZE),
	};
}

function map_manager_is_chunk_loaded(_chunk_x, _chunk_y) {
	return ds_map_exists(global.map.loaded_chunks, map_manager_chunk_key(_chunk_x, _chunk_y));
}

function map_manager_load_chunk(_chunk_x, _chunk_y) {
	var _key = map_manager_chunk_key(_chunk_x, _chunk_y);
	if (ds_map_exists(global.map.loaded_chunks, _key)) {
		return;
	}

	var _tile_id = map_defs_pick_tile_type(_chunk_x, _chunk_y);
	var _tile = map_tile_defs_get(_tile_id);
	var _origin_x = _chunk_x * MAP_TILE_SIZE;
	var _origin_y = _chunk_y * MAP_TILE_SIZE;

	for (var _i = 0; _i < array_length(map_tile_defs_get_props(_tile)); _i++) {
		var _prop = map_tile_defs_get_props(_tile)[_i];
		var _inst = instance_create_layer(
			_origin_x + map_tile_prop_get_offset_x(_prop),
			_origin_y + map_tile_prop_get_offset_y(_prop),
			MAP_PROP_LAYER,
			obj_map_prop
		);
		_inst.prop_frame = map_tile_prop_get_frame(_prop);
		_inst.prop_scale = map_tile_prop_get_scale(_prop);
		_inst.prop_phase = random(1000);
		_inst.chunk_x = _chunk_x;
		_inst.chunk_y = _chunk_y;
		_inst.image_index = map_tile_prop_get_frame(_prop);
		_inst.image_xscale = map_tile_prop_get_scale(_prop);
		_inst.image_yscale = map_tile_prop_get_scale(_prop);
	}

	ds_map_add(global.map.loaded_chunks, _key, _tile_id);
}

function map_manager_unload_chunk(_chunk_x, _chunk_y) {
	var _key = map_manager_chunk_key(_chunk_x, _chunk_y);
	if (!ds_map_exists(global.map.loaded_chunks, _key)) {
		return;
	}

	with (obj_map_prop) {
		if (chunk_x == _chunk_x && chunk_y == _chunk_y) {
			instance_destroy();
		}
	}

	ds_map_delete(global.map.loaded_chunks, _key);
}

function map_manager_update_chunks(_world_x, _world_y) {
	if (!variable_global_exists("map")) {
		map_manager_init();
	}

	// Room restart destroys props but keeps the chunk registry on persistent obj_game
	if (instance_number(obj_map_prop) == 0 && ds_map_size(global.map.loaded_chunks) > 0) {
		ds_map_clear(global.map.loaded_chunks);
	}

	var _pad = MAP_TILE_SIZE * MAP_CHUNK_MARGIN;
	var _bounds = map_manager_get_view_bounds(_pad);
	var _start = map_manager_world_to_chunk(_bounds.left, _bounds.top);
	var _end = map_manager_world_to_chunk(_bounds.right, _bounds.bottom);

	for (var _cx = struct_field(_start, "chunk_x", 0); _cx <= struct_field(_end, "chunk_x", 0); _cx++) {
		for (var _cy = struct_field(_start, "chunk_y", 0); _cy <= struct_field(_end, "chunk_y", 0); _cy++) {
			map_manager_load_chunk(_cx, _cy);
		}
	}

	var _unload_pad = map_manager_get_required_chunk_radius() + MAP_CHUNK_MARGIN;
	var _center = map_manager_world_to_chunk(_world_x, _world_y);
	var _keys = ds_map_keys_to_array(global.map.loaded_chunks);
	for (var _i = 0; _i < array_length(_keys); _i++) {
		var _parts = string_split(_keys[_i], ",");
		var _chunk_x = real(_parts[0]);
		var _chunk_y = real(_parts[1]);
		if (abs(_chunk_x - struct_field(_center, "chunk_x", 0)) > _unload_pad || abs(_chunk_y - struct_field(_center, "chunk_y", 0)) > _unload_pad) {
			map_manager_unload_chunk(_chunk_x, _chunk_y);
		}
	}
}

function map_manager_get_stage() {
	return global.map.stage_index;
}

function map_manager_advance_stage() {
	// Phase 3: gold ticket purchase
}

function map_manager_draw_background() {
	var _pad = MAP_TILE_SIZE;
	var _bounds = map_manager_get_view_bounds(_pad);
	var _start = map_manager_world_to_chunk(_bounds.left, _bounds.top);
	var _end = map_manager_world_to_chunk(_bounds.right, _bounds.bottom);

	for (var _cx = struct_field(_start, "chunk_x", 0); _cx <= struct_field(_end, "chunk_x", 0); _cx++) {
		for (var _cy = struct_field(_start, "chunk_y", 0); _cy <= struct_field(_end, "chunk_y", 0); _cy++) {
			var _tile_id = map_defs_pick_tile_type(_cx, _cy);
			var _tile = map_tile_defs_get(_tile_id);
			draw_set_color(map_tile_defs_get_ground_color(_tile));
			draw_rectangle(
				_cx * MAP_TILE_SIZE,
				_cy * MAP_TILE_SIZE,
				(_cx + 1) * MAP_TILE_SIZE,
				(_cy + 1) * MAP_TILE_SIZE,
				false
			);
		}
	}

	draw_set_color(c_white);
}

function map_manager_ensure() {
	if (!variable_global_exists("map") || !ds_exists(global.map.loaded_chunks, ds_type_map)) {
		map_manager_init();
		return;
	}

	map_manager_init_camera();
}
