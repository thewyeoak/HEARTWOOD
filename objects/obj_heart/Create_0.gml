image_speed = 0

can_move = true; can_graze = true
immunity = false; immunity_time = 1

switch (mode) {
    case soul_mode.overworld:
        can_move = false; can_graze = false
        image_xscale = .5; image_yscale = .5
    break
}