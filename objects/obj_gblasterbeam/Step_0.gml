if (instance_exists(creator)) {
    x = creator.x + lengthdir_x(mouth_offset, image_angle)
    y = creator.y + lengthdir_y(mouth_offset, image_angle)
}

switch (state) {
    case beam_state.fire:
        image_yscale = lerp(image_yscale, max_thickness, grow_lerp)
        break

    case beam_state.fade:
        image_yscale = lerp(image_yscale, 0, shrink_lerp)
        image_alpha -= fade_speed

        if (image_alpha <= 0) {
            instance_destroy()
        }
        break
}