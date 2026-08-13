if !is_undefined(focus)
{
    x = clamp(focus.x - 160, 0, room_width - 320)
    y = clamp(focus.y - 135, 0, room_height - 240)
}

camera_set_view_pos(view_camera[0], x + mod_x, y + mod_y)