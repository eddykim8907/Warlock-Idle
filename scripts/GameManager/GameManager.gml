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
	upgrade_manager_ensure();
	dot_manager_init();
	dot_manager_ensure();
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
	var _entry = upgrade_manager_get_def(_upgrade_id);
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
	draw_text(_x + 8, _y + 8, upgrade_defs_get_label(_entry) + " Lv " + string(_level));
	draw_set_color(_can_buy ? make_color_rgb(200, 220, 200) : make_color_rgb(150, 150, 160));
	draw_text(_x + 8, _y + 28, "Cost: " + string(_cost) + " gold");
	draw_set_color(c_white);

	if (mouse_check_button_pressed(mb_left) && _hover && _can_buy) {
		return upgrade_manager_purchase(_upgrade_id);
	}
	return false;
}

/// @description Generic action button; returns true if clicked
function game_manager_draw_action_button(_x, _y, _w, _h, _title, _subtitle, _can_use) {
	var _mx = device_mouse_x_to_gui(0);
	var _my = device_mouse_y_to_gui(0);
	var _hover = point_in_rectangle(_mx, _my, _x, _y, _x + _w, _y + _h);

	var _fill = _can_use ? make_color_rgb(36, 36, 48) : make_color_rgb(24, 24, 32);
	var _border = _hover ? c_yellow : (_can_use ? make_color_rgb(100, 140, 100) : make_color_rgb(70, 70, 80));

	draw_set_alpha(1);
	draw_set_color(_fill);
	draw_rectangle(_x, _y, _x + _w, _y + _h, false);
	draw_set_color(_border);
	draw_rectangle(_x, _y, _x + _w, _y + _h, true);

	draw_set_color(c_white);
	draw_text(_x + 8, _y + 8, _title);
	draw_set_color(_can_use ? make_color_rgb(200, 220, 200) : make_color_rgb(150, 150, 160));
	draw_text(_x + 8, _y + 28, _subtitle);
	draw_set_color(c_white);

	if (mouse_check_button_pressed(mb_left) && _hover && _can_use) {
		return true;
	}
	return false;
}

function game_manager_draw_hud() {
	draw_set_color(c_white);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_text(16, 16, "Gold: " + (economy_has_infinite_gold() ? "∞" : string(floor(economy_get_gold()))));
	draw_text(16, 40, "Essence: " + string(floor(economy_get_essence())));
	draw_text(16, 64, "Enemies: " + string(instance_number(obj_enemy)));
	draw_text(16, 88, "DoTs: " + string(totem_manager_get_active_dot_count()));
	draw_text(16, 112, "Time: " + string(floor(global.time.elapsed)) + "s");
	draw_text(16, 136, "Damage: " + string(round(stat_manager_get(STAT_ENTITY_PLAYER, "attack_damage"))));
	draw_text(16, 160, "Bleed/tick: " + string(round(stat_manager_get(STAT_ENTITY_TOTEM_BLEED, "bleed_dpt") * 100) / 100));

	game_manager_draw_upgrade_button(16, 190, 260, 56, "wand_damage");
	game_manager_draw_upgrade_button(16, 254, 260, 56, "wand_atk_spd");
	game_manager_draw_upgrade_button(16, 318, 260, 56, "bleed_damage");

	var _bleed_entry = totem_defs_get("bleed");
	var _totem_count = totem_manager_get_count("bleed");
	if (game_manager_draw_action_button(
		16,
		382,
		260,
		56,
		"Bleed Totem (" + string(_totem_count) + "/" + string(totem_defs_get_max_count(_bleed_entry)) + ")",
		"Cost: " + string(totem_defs_get_placement_cost_gold(_bleed_entry)) + " gold",
		totem_manager_can_purchase("bleed")
	)) {
		totem_manager_try_purchase("bleed");
	}

	var _boss_sub = boss_manager_is_active()
		? "Boss active!"
		: "Cost: " + string(global.boss.summon_cost) + " gold";
	if (game_manager_draw_action_button(
		16,
		446,
		260,
		56,
		"Summon Boss",
		_boss_sub,
		boss_manager_can_summon()
	)) {
		boss_manager_summon();
	}

	var _dev_on = economy_has_infinite_gold();
	if (game_manager_draw_action_button(
		VIEW_WIDTH - 176,
		16,
		160,
		40,
		"[DEV] Infinite Gold",
		_dev_on ? "ON — click to disable" : "OFF — click to enable",
		true
	)) {
		economy_dev_toggle_infinite_gold();
	}
}
