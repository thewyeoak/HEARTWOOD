if (!initialized) {
    initialize()
}

if (state == blaster_state.idle || state == blaster_state.charge) {
    x = lerp(x, self_target.x, approach_lerp)
    y = lerp(y, self_target.y, approach_lerp)

    target_angle = point_direction(x, y, target.x, target.y)
    image_angle += angle_difference(target_angle, image_angle) * turn_lerp
}

switch (state) {
    case blaster_state.idle:
        image_index = 0
        break

    case blaster_state.charge:
        if (image_index >= fire_frame) {
            fire()
        }
        break

    case blaster_state.recoil:
        if (image_index < fire_frame) {
            image_index = fire_frame
        }

        if (point_distance(x, y, self_target.x, self_target.y) > despawn_distance) {
            instance_destroy()
        }
        break
}