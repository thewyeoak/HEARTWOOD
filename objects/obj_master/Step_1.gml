global.joystick =
{
    up : gamepad_axis_value(0, gp_axislv) <= -0.5,
    down : gamepad_axis_value(0, gp_axislv) >= 0.5,
    left : gamepad_axis_value(0, gp_axislh) <= -0.5,
    right : gamepad_axis_value(0, gp_axislh) >= 0.5,
}

// pressed and released come from comparing against last frame so the stick gets edge detection too
var _names = variable_struct_get_names(input_map)

var _held = {}
var _pressed = {}
var _released = {}

for (var i = 0; i < array_length(_names); i++) {
    var _name = _names[i]
    var _now = input_down(input_map[$ _name])
    var _was = keys_prev[$ _name] ?? false

    _held[$ _name] = _now
    _pressed[$ _name] = _now && !_was
    _released[$ _name] = !_now && _was
}

global.keys_held = _held
global.keys_pressed = _pressed
global.keys_released = _released
keys_prev = _held

global.time++