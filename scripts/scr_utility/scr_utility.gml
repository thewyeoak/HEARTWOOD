function can_player_move() {
    var _console_closed = !instance_exists(obj_console) || !obj_console.enabled
    var _dialogue_closed = !instance_exists(obj_dialogue)

    return _dialogue_closed && _console_closed && is_undefined(global.current_cutscene) && !global.transitioning
}

// copies every field of _from onto _to, overwriting anything already there
function struct_merge_into(_to, _from) {
    var _keys = variable_struct_get_names(_from)

    for (var i = 0; i < array_length(_keys); i++) {
        _to[$ _keys[i]] = _from[$ _keys[i]]
    }

    return _to
}

// _tint runs from -1 for fully black through 0 for untouched to 1 for fully white
function draw_sprite_tinted(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _color, _alpha, _tint) {
    var _blend = (_tint < 0) ? merge_color(_color, c_black, -_tint) : _color

    draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, _blend, _alpha)

    if (_tint <= 0) {return}

    gpu_set_fog(true, c_white, 0, 0)
    draw_sprite_ext(_sprite, _subimg, _x, _y, _xscale, _yscale, _rot, c_white, _alpha * _tint)
    gpu_set_fog(false, c_white, 0, 0)
}

// draw_self with a tint, for any instance that keeps a tint variable
function draw_self_tinted(_tint) {
    draw_sprite_tinted(sprite_index, image_index, x, y, image_xscale, image_yscale, image_angle, image_blend, image_alpha, _tint)
}

// recreates a surface if the graphics device threw it away, returns the one to draw on
function surface_ensure(_surface, _width, _height) {
    if (surface_exists(_surface)) {return _surface}

    return surface_create(_width, _height)
}

// get_sprite_center for an instance other than the caller
function instance_sprite_center(_inst) {
    var _center = -1

    with (_inst) {
        _center = get_sprite_center()
    }

    return _center
}

function get_sprite_center() {
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
        }
    }

    var _dist = point_distance(0, 0, _cx_offset, _cy_offset)
    var _dir = point_direction(0, 0, _cx_offset, _cy_offset) + image_angle

    return {
        x: x + lengthdir_x(_dist, _dir),
        y: y + lengthdir_y(_dist, _dir)
    }
}