switch (mode) {
    case soul_mode.overworld:
        if (instance_exists(obj_player)) {
            var _target = instance_sprite_center(obj_player)

            x = _target.x
            y = _target.y + 4
        }
    break
}