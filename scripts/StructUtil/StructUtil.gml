/// @description Safe struct field access for GM2026 instance/struct confusion bugs.
/// Avoid these as struct KEYS: id, x, y, speed, direction, depth, visible,
/// sprite_index, image_index, image_xscale, image_yscale, entity, instances, type

function struct_field(_struct, _key, _default) {
	if (!is_struct(_struct)) {
		return _default;
	}
	if (!variable_struct_exists(_struct, _key)) {
		return _default;
	}
	return struct_get(_struct, _key);
}

function struct_is_valid(_struct, _required_keys) {
	if (!is_struct(_struct)) {
		return false;
	}
	for (var i = 0; i < array_length(_required_keys); i++) {
		if (!variable_struct_exists(_struct, _required_keys[i])) {
			return false;
		}
	}
	return true;
}
