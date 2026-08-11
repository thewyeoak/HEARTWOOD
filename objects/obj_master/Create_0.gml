var _width = display_get_width()
var _height = display_get_height()
global.max_scale = min(_width div 640, _height div 480)

global.offset_x = (_width - 640 * global.max_scale) div 2
global.offset_y = (_height - 480 * global.max_scale) div 2
border_alpha = 1

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