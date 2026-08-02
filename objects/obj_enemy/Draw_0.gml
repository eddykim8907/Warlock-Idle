draw_self();

var _bar_w = is_boss ? 28 : 16;
var _bar_h = is_boss ? 4 : 3;
var _bar_y = is_boss ? -22 : -14;
var _pct = clamp(hp / hp_max, 0, 1);
draw_set_color(c_black);
draw_rectangle(x - _bar_w * 0.5 - 1, y + _bar_y, x + _bar_w * 0.5 + 1, y + _bar_y + _bar_h + 2, false);
draw_set_color(is_boss ? make_color_rgb(180, 60, 220) : c_red);
draw_rectangle(x - _bar_w * 0.5, y + _bar_y, x - _bar_w * 0.5 + _bar_w * _pct, y + _bar_y + _bar_h, false);
draw_set_color(c_white);
