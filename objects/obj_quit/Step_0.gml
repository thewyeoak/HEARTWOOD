scale = global.max_scale / 2

if (!global.keys_held.escape) {
    image_alpha = 0
    image_index = 0
    time = 0

    ease_cancel(id, "image_alpha")
    exit
}

if (++time == hold_frames) {
    game_end()
}

if (global.keys_pressed.escape) {
    ease_alpha(id, 1, .5, easing.linear)
}

image_index = time / 10