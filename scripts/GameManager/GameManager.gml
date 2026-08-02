/// @description Bootstrap all game systems
function game_manager_init() {
	randomize();
	global.game = {
		state: GAME_STATE_PLAYING,
	};

	time_manager_init();
	stat_manager_init();
	economy_manager_init();
	upgrade_manager_init();
	dot_manager_init();
	spawn_manager_init();
	totem_manager_init();
	boss_manager_init();
	map_manager_init();
	combat_manager_init_damage_numbers();
}

function game_manager_set_state(_state) {
	global.game.state = _state;
}

function game_manager_is_playing() {
	return global.game.state == GAME_STATE_PLAYING;
}

/// @description Draw upgrade button; returns true if clicked this frame
function game_manager_draw_upgrade_button(_x, _y, _w, _h, _upgrade_id) {
	var _def = upgrade_manager_get_def(_upgrade_id);
	var _level = upgrade_manager_get_level(_upgrade_id);
	var _cost = upgrade_manager_get_cost(_upgrade_id);
	var _can_buy = upgrade_manager_can_purchase(_upgrade_id);
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	var _hover = point_in_rectangle(_mx, _my, _x, _y, _x + _w, _y + _h);

	var _fill = _can_buy ? make_color_rgb(36, 36, 48) : make_color_rgb(24, 24, 32);
	var _border = _hover ? c_yellow : (_can_buy ? make_color_rgb(100, 140, 100) : make_color_rgb(70, 70, 80));

	draw_set_alpha(1);
	draw_set_color(_fill);
	draw_rectangle(_x, _y, _x + _w, _y + _h, false);
	draw_set_color(_border);
	draw_rectangle(_x, _y, _x + _w, _y + _h, true);

	draw_set_color(c_white);
	draw_text(_x + 8, _y + 8, _def.label + " Lv " + string(_level));
	draw_set_color(_can_buy ? make_color_rgb(200, 220, 200) : make_color_rgb(150, 150, 160));
	draw_text(_x + 8, _y + 28, "Cost: " + string(_cost) + " gold");
	draw_set_color(c_white);

	if (mouse_check_button_pressed(mb_left) && _hover && _can_buy) {
		return upgrade_manager_purchase(_upgrade_id);
	}
	return false;
}

function game_manager_draw_hud() {
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(16, 16, "Gold: " + string(floor(economy_get_gold())));
	draw_text(16, 40, "Enemies: " + string(instance_number(obj_enemy)));
	draw_text(16, 64, "Time: " + string(floor(global.time.elapsed)) + "s");
	draw_text(16, 88, "Damage: " + string(round(stat_manager_get(STAT_ENTITY_PLAYER, "attack_damage"))));
	draw_text(16, 112, "Atk Spd: " + string(round(stat_manager_get(STAT_ENTITY_PLAYER, "attack_speed") * 100) / 100));

	game_manager_draw_upgrade_button(16, 150, 260, 56, "wand_damage");
	game_manager_draw_upgrade_button(16, 214, 260, 56, "wand_atk_spd");
}
