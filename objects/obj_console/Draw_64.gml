console_surface = surface_ensure(console_surface, width, game_height)
surface_set_target(console_surface)
draw_clear_alpha(c_black, 0)
draw_set_font(fnt_dialogue_battle)

var _outline_width = 1

var _horizontal_padding = 32
var _vertical_padding = 7

var _line_height = 20

var _total_height = height - (input_height+log_height)

draw_set_colour(c_black)
draw_rectangle(0, _total_height, width, height, false) // IF I DREW TWO RECTANGLES, HOW COULD I ENSURE MY STROKES WONT BLEED INTO THE LINE, CORRUPTING IT’S PURITY?

draw_set_colour(c_white)
draw_line_width(0, height - input_height, width, height - input_height, _outline_width)
draw_line_width(0, _total_height, width, _total_height, _outline_width)

var _prompt = "$ "
draw_set_colour(c_white)
draw_text(_horizontal_padding, height - (input_height - _vertical_padding), wrap_formatted_text(_prompt, char_limit, false))

var _input_x = _horizontal_padding * 1.25 + string_width(_prompt)
var _input_y = height - (input_height - _vertical_padding)

if (autocomplete_match != "") {
    draw_set_colour(c_dkgray)
    draw_text(_input_x, _input_y, wrap_formatted_text(autocomplete_match, char_limit, false))
}

var _input_color = (autocomplete_match != "") ? c_yellow : c_gray

draw_set_colour(_input_color)
draw_text(_input_x, _input_y, wrap_formatted_text(input_string, char_limit, false))

var _log_y = height - input_height - _vertical_padding

for (var i = array_length(logs) - 1 - scroll_offset; i >= 0; i--) {
    _log_y -= _line_height
    if (_log_y < _total_height) break
        
    draw_set_colour(logs[i].color)
    draw_text(_horizontal_padding, _log_y, logs[i].text)
}

surface_reset_target()
draw_surface(console_surface, 0, 0)