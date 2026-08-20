image_speed = 0

can_move = true
can_graze = true

immunity = false
immunity_time = 1
immunity_timer = 0

visage_scale = image_xscale
visage_alpha = 0

palette_colors = shader_get_uniform(sh_palette, "colors")
palette_sampler = shader_get_sampler_index(sh_palette, "palettes")

// the ring that expands out of the soul as it appears for color changes n such
function create_visage(_scale = 2.5) {
    play_sfx(snd_bell, 1)

    visage_scale = image_xscale
    visage_alpha = 1

    var _ease_time = 0.3
    ease_start(id, "visage_scale", image_xscale * _scale, _ease_time, easing.linear)
    ease_start(id, "visage_alpha", 0, _ease_time, easing.linear)
}

function switch_mode(_mode) {
    mode = _mode

    switch (_mode) {
        case soul_mode.overworld:
            can_move = false
            can_graze = false
            image_xscale = 0.5
            image_yscale = 0.5
        break
    }

    create_visage()
}

function die() { // this is my favorite function i think
    obj_hud.enabled = false
    obj_hud.anim_offset = obj_hud.total_height
    obj_master.fade_out(0, easing.linear)

    var _cam = view_camera[0]
    var _cam_x = camera_get_view_x(_cam)
    var _cam_y = camera_get_view_y(_cam)
    var _cam_w = camera_get_view_width(_cam)
    var _cam_h = camera_get_view_height(_cam)

    global.death_x = ((x - _cam_x) / _cam_w) * game_width
    global.death_y = ((y - _cam_y) / _cam_h) * game_height
    global.death_scale = image_xscale * (game_width / _cam_w)

    global.stats.hp = global.stats.max_hp
    room_goto(rm_gameover)
}

if (!variable_instance_exists(id, "mode")) {mode = soul_mode.battle}

switch_mode(mode)