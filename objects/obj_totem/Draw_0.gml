draw_self();

var _entry = totem_defs_get(totem_type);
draw_set_alpha(0.08);
draw_set_color(image_blend);
draw_circle(x, y, totem_defs_get_attack_range(_entry), false);
draw_set_alpha(1);
draw_set_color(c_white);
