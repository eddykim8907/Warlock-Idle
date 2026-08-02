totem_type = "bleed";
orbit_angle = 0;
orbit_offset = 0;
orbit_radius = 90;
fire_cooldown = 0;

depth = -50;
sprite_index = ASSET_SPRITE;
image_speed = 0;
image_angle = 0;
image_blend = make_color_rgb(220, 70, 70);

var _entry = totem_defs_get(totem_type);
image_index = totem_defs_get_sprite_frame(_entry);
image_xscale = totem_defs_get_sprite_scale(_entry);
image_yscale = totem_defs_get_sprite_scale(_entry);
