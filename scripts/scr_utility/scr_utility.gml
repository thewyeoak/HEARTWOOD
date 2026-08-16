function can_player_move() {
    var _console_closed = !instance_exists(obj_console) || !obj_console.enabled
    var _dialogue_closed = !instance_exists(obj_dialogue_box)

    return _dialogue_closed && _console_closed && is_undefined(global.current_cutscene)
}

function get_sprite_center() 
{
    if (sprite_index == -1) {
        return { x: x, y: y }
    }

    var _cx_offset = (sprite_get_width(sprite_index) / 2) - sprite_get_xoffset(sprite_index)
    var _cy_offset = (sprite_get_height(sprite_index) / 2) - sprite_get_yoffset(sprite_index)

    _cx_offset *= image_xscale
    _cy_offset *= image_yscale

    if (image_angle == 0) {
        return {
            x: x + _cx_offset,
            y: y + _cy_offset
        };
    }

    var _dist = point_distance(0, 0, _cx_offset, _cy_offset);
    var _dir = point_direction(0, 0, _cx_offset, _cy_offset) + image_angle

    return {
        x: x + lengthdir_x(_dist, _dir),
        y: y + lengthdir_y(_dist, _dir)
    }
}