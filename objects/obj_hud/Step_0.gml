if (enabled != prev_enabled) {
    var _target_offset = enabled ? 0 : total_height

    ease_start(id, "anim_offset", _target_offset, slide_time, slide_ease)
    prev_enabled = enabled
}
