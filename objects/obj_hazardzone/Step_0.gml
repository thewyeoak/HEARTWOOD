if (!enabled) {exit}

active = place_meeting(x, y, obj_player)

if (active != prev_active) {
    if (active) {
        enter_zone()
    } else {
        exit_zone()
    }
}

prev_active = active

if (active && active_pattern == noone && bullet_pattern != noone) {
    active_pattern = instance_create_depth(x, y, layer_get_depth("Systems") + 1, bullet_pattern, {creator: id})
} else if (!active && active_pattern != noone) {
    if (instance_exists(active_pattern)) {
        instance_destroy(active_pattern)
    }

    active_pattern = noone
}