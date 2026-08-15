if (enabled != prev_enabled) {
    var _ease_type = easing.out_cubic
    var _ease_spd = 0.4
    var _target_offset = enabled ? 0 : total_height
    ease_start(id, "anim_offset", _target_offset, _ease_spd, _ease_type)
    prev_enabled = enabled
}
