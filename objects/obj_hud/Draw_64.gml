if (!surface_exists(display_surface)) {
    display_surface = surface_create(640, 480)
}

surface_set_target(display_surface)
draw_clear_alpha(c_black, 0)
draw_set_font(fnt_curs)

var _top_y1 = -anim_offset
var _top_y2 = total_height - anim_offset

var _bottom_y1 = (height - total_height) + anim_offset
var _bottom_y2 = height + anim_offset

draw_set_colour(c_black)

draw_rectangle(0, _bottom_y1, width, _bottom_y2, false)
draw_rectangle(0, _top_y1, width, _top_y2, false)

draw_set_colour(c_white)

draw_text(h_offsets.name, _bottom_y1 + v_offset, global.current_file.player_name)
draw_text(h_offsets.lv, _bottom_y1 + v_offset, "LV " + string(global.stats.lv))
draw_sprite(spr_hp_label, 0, h_offsets.hp_label, _bottom_y1 + 15)

var _bar_length = h_offsets.hp + (global.stats.max_hp * 1.2)
draw_healthbar(
    h_offsets.hp, 
    _bottom_y1 + v_offset, 
    _bar_length, 
    _bottom_y1 + 30, 
    (global.stats.hp / global.stats.max_hp) * 100, 
    c_red, c_yellow, c_yellow, 
    0, true, false
)

var _current_hp = ceil(global.stats.hp)
var _hp_string = _current_hp < 10 ? "0" + string(_current_hp) : string(_current_hp)

draw_text(_bar_length + 15, _bottom_y1 + v_offset, $"{_hp_string} / {global.stats.max_hp}")

surface_reset_target()
draw_surface(display_surface, 0, 0)