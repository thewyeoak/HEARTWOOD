function update_window() {
    var _has_border = (global.settings.border != global.borders.off)

    var _base_w = _has_border ? 960 : 640
    var _base_h = _has_border ? 540 : 480

    if (window_get_fullscreen()) {
        var _display_w = display_get_width()
        var _display_h = display_get_height()

        var _scale = min(_display_w / _base_w, _display_h / _base_h)
        global.draw_scale = max(1, _scale)
        global.offset_x = (_display_w - (_base_w * global.draw_scale)) div 2
        global.offset_y = (_display_h - (_base_h * global.draw_scale)) div 2

    } else {
        global.draw_scale = global.settings.window_scale
        
        window_set_size(_base_w * global.draw_scale, _base_h * global.draw_scale)
        call_later(10, time_source_units_frames, window_center)

        global.offset_x = 0
        global.offset_y = 0
    }

    var _gui_x = global.offset_x
    var _gui_y = global.offset_y
    
    if (_has_border) {
        _gui_x += (160 * global.draw_scale)
        _gui_y += (30 * global.draw_scale)
    }

    display_set_gui_maximize(global.draw_scale, global.draw_scale, _gui_x, _gui_y)
}