if (global.keys_pressed.debug && global.debug.console) {
    enabled = !enabled
    
    if enabled {
        ease_start(id, "height", 480, 0.75, easing.in_cubic)
    } else {
        ease_start(id, "height", 730, 1, easing.out_cubic)
    }
}

if !global.debug.console || !enabled {exit}

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

if (string_length(input_string) >= 3 && string_pos(" ", input_string) == 0) {
    for (var i = 0; i < array_length(commands); i++) {
        if (string_starts_with(commands[i].name, input_string)) {
            autocomplete_match = commands[i].name
            break 
        }
    }
}

if (keyboard_check_pressed(vk_tab) && autocomplete_match != "") {
    keyboard_string = autocomplete_match
    input_string = keyboard_string
}

if (keyboard_check_pressed(vk_up) && array_length(command_history) > 0) {
    history_index = max(0, history_index - 1)
    keyboard_string = command_history[history_index]
    input_string = keyboard_string
}

if (keyboard_check_pressed(vk_down) && array_length(command_history) > 0) {
    if (history_index < array_length(command_history) - 1) {
        history_index++
        keyboard_string = command_history[history_index]
        input_string = keyboard_string
    } 
    else {
        history_index = array_length(command_history)
        keyboard_string = ""
        input_string = ""
    }
}

if (mouse_wheel_up()) {
    var _max_scroll = max(0, array_length(logs) - 1)
    scroll_offset = min(scroll_offset + 1, _max_scroll)
}

if (mouse_wheel_down()) {
    scroll_offset = max(0, scroll_offset - 1)
}