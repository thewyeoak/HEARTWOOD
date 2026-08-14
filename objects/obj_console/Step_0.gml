if (global.keys_pressed.debug && global.debug.console) {
    enabled = !enabled
    var _ease_type = easing.out_cubic
    var _ease_spd = 0.8
    var _check = enabled ? open_height : close_height
    
    keyboard_string = ""
    input_string = ""
    if (enabled) {
        history_index = array_length(command_history)
    }
    
    ease_start(id, "height", _check, _ease_spd, _ease_type)
}

if (!global.debug.console || !enabled) {exit}

keyboard_string = normalize_input(keyboard_string)

if (string_length(keyboard_string) > char_limit) {
    keyboard_string = string_copy(keyboard_string, 1, char_limit)
}

input_string = keyboard_string

if (keyboard_check_pressed(vk_enter)) {
    run_command(input_string)
    keyboard_string = ""
    input_string = ""
    autocomplete_match = ""
}

autocomplete_match = ""
var _first_space = string_pos(" ", input_string)

if (_first_space == 0) {
    if (string_length(input_string) >= 2) {
        for (var i = 0; i < array_length(commands); i++) {
            if (string_starts_with(commands[i].name, input_string)) {
                autocomplete_match = commands[i].name
                break 
            }
        }
    }
} else {
    var _cmd_name = string_copy(input_string, 1, _first_space - 1)
    var _cmd = undefined
    
    for (var i = 0; i < array_length(commands); i++) {
        if (commands[i].name == _cmd_name) {
            _cmd = commands[i]
            break
        }
    }
    
    if (_cmd != undefined) {
        var _tokens = string_split(input_string, " ")
        var _token_count = array_length(_tokens)
        
        var _arg_index = _token_count - 2
        var _opt_args = _cmd[$ "optional_args"] ?? [];
        var _total_args = array_length(_cmd.args) + array_length(_opt_args)
        
        if (_arg_index >= 0 && _arg_index < _total_args) {
            var _partial_arg = _tokens[_token_count - 1]
            if (string_length(_partial_arg) >= 2) { 
                var _options = get_arg_options(_cmd, _arg_index)
                
                for (var o = 0; o < array_length(_options); o++) {
                    if (string_starts_with(_options[o], _partial_arg)) {
                        var _prefix = string_copy(input_string, 1, string_length(input_string) - string_length(_partial_arg))
                        autocomplete_match = _prefix + _options[o]
                        break
                    }
                }
            }
        }
    }
}

if (keyboard_check_pressed(vk_tab) && autocomplete_match != "") {
    keyboard_string = autocomplete_match
    input_string = keyboard_string
}

if (keyboard_check(vk_backspace)) {
    backspace_timer++
    if (backspace_timer > 10) && (string_length(input_string) > 0)  {
        input_string = string_delete(input_string, string_length(input_string), 1)
        keyboard_string = input_string
    }
} else {
    backspace_timer = 0
}

if (mouse_wheel_up()) {
    var _max_scroll = max(0, array_length(logs) - 1)
    scroll_offset = min(scroll_offset + 1, _max_scroll)
}

if (mouse_wheel_down()) {
    scroll_offset = max(0, scroll_offset - 1)
}