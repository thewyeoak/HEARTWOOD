switch (mode) {
    case soul_mode.overworld:
        if (instance_exists(obj_player)) {
            var _target = -1
            with (obj_player) {
                _target = get_sprite_center()
            }
            
            x = _target.x
            y = _target.y + 4
        }
    break
}