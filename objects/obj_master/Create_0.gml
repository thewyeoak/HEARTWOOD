var _width = display_get_width()
var _height = display_get_height()
global.max_scale = min(_width div game_width, _height div game_height)

global.offset_x = (_width - game_width * global.max_scale) div 2
global.offset_y = (_height - game_height * global.max_scale) div 2

border_alpha = 1
fade_alpha = 0
fade_color = c_black

global.settings = {
    window_scale: 1,
    border: global.borders.blank,
    volume_music: 0.2,
    volume_sfx: 1,
    volume_master: 1
}

global.files = {
    file_1: {
        exists: false,
        player_name: "CHARA", // temporary
        playtime: undefined,
        save_location: rm_test, // temporary
        fun: undefined,
        flags: []
    }
}

global.rooms = []
global.room_names = []
var _current_room = room_first

while (_current_room != -1) {
    array_push(global.rooms, _current_room)
    array_push(global.room_names, room_get_name(_current_room))
    _current_room = room_next(_current_room)
}

global.current_file = global.files.file_1 // temporary

audio_group_set_gain(audiogroup_default, global.settings.volume_music * global.settings.volume_master, 0)
audio_group_set_gain(audiogroup_sfx, global.settings.volume_sfx * global.settings.volume_master, 0)

audio_group_load(audiogroup_default)
audio_group_load(audiogroup_sfx)

surface_resize(application_surface, game_width, game_height)
application_surface_draw_enable(false)
gpu_set_texfilter(false)

update_window()

exception_unhandled_handler(function(ex) {
    play_sfx(snd_glassbreak, 0.5)

    var _error_text = "I don't think that was supposed to happen..." + ex.longMessage
    show_message(_error_text)

    return 0
})

// each action lists the keys and pad buttons that trigger it plus an optional stick direction
input_map = {
    up: {keys: [vk_up], pads: [gp_padu], stick: "up"},
    down: {keys: [vk_down], pads: [gp_padd], stick: "down"},
    left: {keys: [vk_left], pads: [gp_padl], stick: "left"},
    right: {keys: [vk_right], pads: [gp_padr], stick: "right"},
    confirm: {keys: [ord("Z"), vk_enter], pads: [gp_face2]},
    cancel: {keys: [ord("X"), vk_shift], pads: [gp_face1, gp_stickl]},
    menu: {keys: [ord("C"), vk_control], pads: [gp_face4]},
    escape: {keys: [vk_escape], pads: [gp_start]},
    debug: {keys: [vk_f2], pads: []}
}

keys_prev = {}

function input_down(_entry) {
    for (var i = 0; i < array_length(_entry.keys); i++) {
        if (keyboard_check(_entry.keys[i])) {return true}
    }

    for (var i = 0; i < array_length(_entry.pads); i++) {
        if (gamepad_button_check(0, _entry.pads[i])) {return true}
    }

    var _stick = _entry[$ "stick"]

    return !is_undefined(_stick) && global.joystick[$ _stick]
}

function fade_to(_duration, _ease, _to, _depth = -100, _callback = undefined) {
    depth = _depth
    ease_start(self, "fade_alpha", _to, _duration, _ease, _callback)
}

function fade_in(_duration, _ease, _color = c_black, _depth = -100, _callback = undefined) {
    fade_color = _color
    fade_alpha = 0
    fade_to(_duration, _ease, 1, _depth, _callback)
}

function fade_out(_duration, _ease, _depth = -100, _callback = undefined) {
    fade_alpha = 1
    fade_to(_duration, _ease, 0, _depth, _callback)
}

transition_pending = undefined
// _target is a struct of {room, dummy_index}; an unreachable room respawns in the current one
function transition_to(_target, _duration = 0.5, _depth = -100) {
    if (global.transitioning) {return}

    global.transitioning = true
    transition_pending = {
        room: _target.room,
        dummy_index: _target.dummy_index,
        duration: _duration,
        depth: _depth
    }

    fade_in(_duration, easing.linear, c_black, _depth, transition_arrive)
}

function transition_arrive() {
    global.spawn_index = transition_pending.dummy_index

    try {room_goto(transition_pending.room)}
    catch (invalid_room) {
        with (obj_dummy) { update_dummy() }
    }

    fade_out(transition_pending.duration, easing.linear, transition_pending.depth, transition_finish)
}

function transition_finish() {
    global.transitioning = false
    transition_pending = undefined
}