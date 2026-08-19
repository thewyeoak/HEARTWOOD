global.current_music = undefined
global.current_fade_routine = -1

//@param {Asset.GMSound} music The music to play.
function play_music(music) {
    if (global.current_music != undefined) {audio_stop_sound(global.current_music)}
    global.current_music = audio_play_sound(music, 0, true)
}

//@param {Asset.GMSound} sound The sound effect to play.
function play_sfx(sound, _gain_multiplier = 1, _pitch = 1) {
    var _snd = audio_play_sound(sound, 1, false)
    audio_sound_pitch(_snd, _pitch)
    
    var _final_gain = _gain_multiplier * global.settings.volume_sfx * global.settings.volume_master
    audio_sound_gain(_snd, _final_gain, 0)
    
    return _snd
}

function fade_music(to, time, minimum = 0)
{
    if (global.current_fade_routine != -1) {
        stop_coroutine(global.current_fade_routine)
    }
    
    var _fade_data = {
        nextmus: to,
        nexttime: time * 1000,
        min_vol: minimum
    }
    
    audio_group_set_gain(audiogroup_default, _fade_data.min_vol, _fade_data.nexttime)
    
    global.current_fade_routine = call_when_true(
        method(_fade_data, function() {
            return audio_group_get_gain(audiogroup_default) <= min_vol
        }),
        method(_fade_data, function()
        {
            if (nextmus != noone && nextmus != undefined) {
                play_music(nextmus)
                audio_group_set_gain(audiogroup_default, global.settings.volume_music * global.settings.volume_master, nexttime)
            } 
            else {
                if (global.current_music != undefined) {
                    audio_stop_sound(global.current_music)
                    global.current_music = undefined
                }
                audio_group_set_gain(audiogroup_default, global.settings.volume_music * global.settings.volume_master, 0)
            }
            
            global.current_fade_routine = -1
        })
    )
}

function stop_all_sounds()
{
    audio_stop_all()
    global.current_music = undefined
    global.current_fade_routine = -1
}