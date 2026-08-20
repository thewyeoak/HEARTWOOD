if (!found_player && is_undefined(focus) && instance_exists(obj_player)) {
    focus = instance_find(obj_player, 0)
    found_player = true
}