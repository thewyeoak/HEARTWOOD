var _width = display_get_width()
var _height = display_get_height()
global.max_scale = min(_width div 640, _height div 480)

global.offset_x = (_width - 640 * global.max_scale) div 2
global.offset_y = (_height - 480 * global.max_scale) div 2
border_alpha = 1; fade_alpha = 0
fade_color = c_black

global.settings = 
{
    window_scale: 1,
    border: global.borders.blank,
    volume_music: 1,
    volume_sfx: 1,
    volume_master: 1
}

global.files = 
{
    file_1: 
    {
        exists: false,
        player_name: undefined,
        playtime: undefined,
        save_location: undefined,
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

global.current_file = undefined
global.current_cutscene = undefined
global.time = 0

audio_group_set_gain(audiogroup_default, global.settings.volume_music * global.settings.volume_master, 0)
audio_group_set_gain(audiogroup_sfx, global.settings.volume_sfx * global.settings.volume_master, 0)

audio_group_load(audiogroup_default)
audio_group_load(audiogroup_sfx)

surface_resize(application_surface, 640, 480)
application_surface_draw_enable(false)
gpu_set_texfilter(false)

update_window()

function fade_in(_duration, _ease, _color = c_black, _depth = -100, _callback = undefined) 
{
    depth = _depth
    fade_color = _color
    fade_alpha = 0
    ease_start(self, "fade_alpha", 1, _duration, _ease, _callback)
}

function fade_out(_duration, _ease, _depth = -100, _callback = undefined) 
{
    depth = _depth
    fade_alpha = 1
    ease_start(self, "fade_alpha", 0, _duration, _ease, _callback)
}

function fade_to(_duration, _ease, _to, _depth = -100, _callback = undefined) 
{
    depth = _depth
    ease_start(self, "fade_alpha", _to, _duration, _ease, _callback)
}