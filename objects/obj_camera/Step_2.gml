if (!is_undefined(focus)) {
    x = clamp(focus.x - 160, 0, room_width - 320)
    y = clamp(focus.y - 135, 0, room_height - 240)
}

if (shake_magnitude > 0) {
    mod_x = random_range(-shake_magnitude, shake_magnitude)
    mod_y = random_range(-shake_magnitude, shake_magnitude)
    
    shake_magnitude -= shake_decay;
} else {
    shake_magnitude = 0
    mod_x = 0
    mod_y = 0
}

camera_set_view_pos(view_camera[0], x + mod_x, y + mod_y)