if (prop_frame == ASSET_FRAME_MAP_FIRE) {
	var _alpha = 0.75 + sin(current_time / 180 + prop_phase) * 0.25;
	draw_sprite_ext(
		sprite_index,
		image_index,
		x,
		y,
		image_xscale,
		image_yscale,
		image_angle,
		image_blend,
		_alpha
	);
} else {
	draw_self();
}
