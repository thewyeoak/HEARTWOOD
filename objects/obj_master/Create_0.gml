var width = display_get_width()
var height = display_get_height()
global.max_scale = min(width / 640, height / 480)
global.max_scale_integer = min(width div 640, height div 480)

gpu_set_texfilter(false)

global.settings = 
{
    window_scale: max(1, global.max_scale_integer - 1),
    integer_scaling: false,
    borders: undefined,
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

global.current_file = undefined
global.current_cutscene = undefined
global.time = 0

audio_group_set_gain(audiogroup_default, global.settings.volume_music * global.settings.volume_master, 0)
audio_group_set_gain(audiogroup_sfx, global.settings.volume_sfx * global.settings.volume_master, 0)

global.offset_x = (width - 640 * global.max_scale) div 2
global.offset_x_integer = (width - 640 * global.max_scale_integer) div 2
global.offset_y_integer = (height - 480 * global.max_scale_integer) div 2

window_set_fullscreen(false)
window_set_size(640 * global.settings.window_scale, 480 * global.settings.window_scale)
window_center()

audio_group_load(audiogroup_default)
audio_group_load(audiogroup_sfx)

load_all()