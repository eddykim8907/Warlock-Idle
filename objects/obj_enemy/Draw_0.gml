draw_self();

// HP bar
var _bar_w = 16;
var _bar_h = 3;
var _pct = clamp(hp / hp_max, 0, 1);
draw_set_color(c_black);
draw_rectangle(x - _bar_w * 0.5 - 1, y - 14, x + _bar_w * 0.5 + 1, y - 14 + _bar_h + 2, false);
draw_set_color(c_red);
draw_rectangle(x - _bar_w * 0.5, y - 14, x - _bar_w * 0.5 + _bar_w * _pct, y - 14 + _bar_h, false);
draw_set_color(c_white);
