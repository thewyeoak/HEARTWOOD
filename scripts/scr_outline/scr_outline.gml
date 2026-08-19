function draw_outline(outline_width, outline_color, outline_alpha)
{
    var _w = sprite_get_width(sprite_index) * abs(image_xscale)
    var _h = sprite_get_height(sprite_index) * abs(image_yscale)
    var _xo = sprite_get_xoffset(sprite_index) * abs(image_xscale)
    var _yo = sprite_get_yoffset(sprite_index) * abs(image_yscale)
    
    var _max_d = max(
        point_distance(_xo, _yo, 0, 0),
        point_distance(_xo, _yo, _w, 0),
        point_distance(_xo, _yo, 0, _h),
        point_distance(_xo, _yo, _w, _h)
    );
    
    var _size = ceil(_max_d * 2) + (outline_width * 4)
    
    static _surf = -1
    static _surf_size = 0
    
    if (!surface_exists(_surf) || _surf_size < _size) {
        if (surface_exists(_surf)) surface_free(_surf)
        _surf = surface_create(_size, _size)
        _surf_size = _size
    }
    
    surface_set_target(_surf)
    draw_clear_alpha(c_black, 0)
    
    gpu_set_fog(true, outline_color, 0, 0)
    
    var __xdirA = outline_width
    var __xdirB = 0
    var __ydirA = 0
    var __ydirB = outline_width
    
    if ((image_angle % 90) != 0)
    {
        __xdirA = lengthdir_x(outline_width, image_angle)
        __xdirB = lengthdir_x(outline_width, image_angle + 90)
        __ydirA = lengthdir_y(outline_width, image_angle + 90)
        __ydirB = lengthdir_y(outline_width, image_angle)
    }
    
    var _cx = _size div 2
    var _cy = _size div 2
    
    draw_sprite_ext(sprite_index, image_index, _cx + __xdirA, _cy + __ydirA, image_xscale, image_yscale, image_angle, c_white, 1)
    draw_sprite_ext(sprite_index, image_index, _cx - __xdirA, _cy - __ydirA, image_xscale, image_yscale, image_angle, c_white, 1)
    draw_sprite_ext(sprite_index, image_index, _cx + __xdirB, _cy + __ydirB, image_xscale, image_yscale, image_angle, c_white, 1)
    draw_sprite_ext(sprite_index, image_index, _cx - __xdirB, _cy - __ydirB, image_xscale, image_yscale, image_angle, c_white, 1)
    
    gpu_set_fog(false, c_white, 0, 0)
    surface_reset_target();
    
    draw_surface_ext(_surf, x - _cx, y - _cy, 1, 1, 0, c_white, image_alpha * outline_alpha)
}

function draw_outline_ext(sprite, subimg, outline_x, outline_y, outline_xscale, outline_yscale, outline_rot, outline_color, outline_alpha, outline_width)
{
    var _w = sprite_get_width(sprite) * abs(outline_xscale)
    var _h = sprite_get_height(sprite) * abs(outline_yscale)
    var _xo = sprite_get_xoffset(sprite) * abs(outline_xscale)
    var _yo = sprite_get_yoffset(sprite) * abs(outline_yscale)
    
    var _max_d = max(
        point_distance(_xo, _yo, 0, 0),
        point_distance(_xo, _yo, _w, 0),
        point_distance(_xo, _yo, 0, _h),
        point_distance(_xo, _yo, _w, _h)
    );
    
    var _size = ceil(_max_d * 2) + (outline_width * 4)
    
    static _surf = -1
    static _surf_size = 0
    
    if (!surface_exists(_surf) || _surf_size < _size) {
        if (surface_exists(_surf)) surface_free(_surf)
        _surf = surface_create(_size, _size)
        _surf_size = _size
    }
    
    surface_set_target(_surf)
    draw_clear_alpha(c_black, 0)
    
    gpu_set_fog(true, outline_color, 0, 0)
    
    var __xdirA = outline_width
    var __xdirB = 0
    var __ydirA = 0
    var __ydirB = outline_width
    
    if ((outline_rot % 90) != 0)
    {
        __xdirA = lengthdir_x(outline_width, outline_rot)
        __xdirB = lengthdir_x(outline_width, outline_rot + 90)
        __ydirA = lengthdir_y(outline_width, outline_rot + 90)
        __ydirB = lengthdir_y(outline_width, outline_rot)
    }
    
    var _cx = _size div 2
    var _cy = _size div 2
    
    draw_sprite_ext(sprite, subimg, _cx + __xdirA, _cy + __ydirA, outline_xscale, outline_yscale, outline_rot, c_white, 1)
    draw_sprite_ext(sprite, subimg, _cx - __xdirA, _cy - __ydirA, outline_xscale, outline_yscale, outline_rot, c_white, 1)
    draw_sprite_ext(sprite, subimg, _cx + __xdirB, _cy + __ydirB, outline_xscale, outline_yscale, outline_rot, c_white, 1)
    draw_sprite_ext(sprite, subimg, _cx - __xdirB, _cy - __ydirB, outline_xscale, outline_yscale, outline_rot, c_white, 1)
    
    gpu_set_fog(false, c_white, 0, 0)
    surface_reset_target()
    
    draw_surface_ext(_surf, outline_x - _cx, outline_y - _cy, 1, 1, 0, c_white, outline_alpha)
}