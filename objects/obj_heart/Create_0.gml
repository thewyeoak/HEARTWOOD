image_speed = 0

can_move = true; can_graze = true
immunity = false; immunity_time = 1

function switch_mode(_mode) {
    switch (_mode) {
        case soul_mode.overworld:
            can_move = false; can_graze = false
            image_xscale = 0.5; image_yscale = 0.5
            mode = _mode
        break
    }
    create_visage()
}

if (mode) {switch_mode(mode)}

visage_scale = image_xscale; visage_alpha = 0

function create_visage(_scale = 2.5) {
    audio_play_sound(snd_bell, 10, false)
    visage_scale = image_xscale; visage_alpha = 1
    
    var _ease_time = 0.3
    ease_start(id, "visage_scale", image_xscale * _scale, _ease_time, easing.linear)
    ease_start(id, "visage_alpha", 0, _ease_time, easing.linear)
}