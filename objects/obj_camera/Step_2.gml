var _eased = ease_is_active(id, "x") || ease_is_active(id, "y")

if (!is_undefined(focus) && !_eased) {
    x = clamp(focus.x - focus_offset_x, 0, room_width - view_width)
    y = clamp(focus.y - focus_offset_y, 0, room_height - view_height)
}

if (shake_magnitude > 0) {
    mod_x = random_range(-shake_magnitude, shake_magnitude)
    mod_y = random_range(-shake_magnitude, shake_magnitude)

    shake_magnitude -= shake_decay * 60 * (delta_time / 1000000)
} else {
    shake_magnitude = 0
    mod_x = 0
    mod_y = 0
}

camera_set_view_pos(cam, x + mod_x, y + mod_y)