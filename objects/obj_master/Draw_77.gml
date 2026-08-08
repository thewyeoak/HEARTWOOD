var _has_border = (global.settings.border != borders.off)

if (_has_border) {
    draw_sprite_ext(spr_borders, global.settings.border, global.offset_x, global.offset_y, global.draw_scale, global.draw_scale, 0, c_white, 1)
}

var _app_x = global.offset_x
var _app_y = global.offset_y

if (_has_border) {
    _app_x += (160 * global.draw_scale)
    _app_y += (30 * global.draw_scale)
}

draw_surface_ext(application_surface, _app_x, _app_y, global.draw_scale, global.draw_scale, 0, c_white, 1)