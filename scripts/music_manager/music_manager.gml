global.current_music = undefined;
global.current_fade_routine = -1;

//@param {Asset.GMSound} music The music to play.
function play_music(music)
{
    if (global.current_music != undefined) { audio_stop_sound(global.current_music); }
    
    global.current_music = audio_play_sound(music, 0, true);
}

function fade_music(to, time, minimum = 0)
{
    if (global.current_fade_routine != -1)
    {
        stop_coroutine(global.current_fade_routine)
    }
    
    nextmus = to;
    nexttime = time;
    audio_group_set_gain(audiogroup_default, minimum, time)
    
    global.current_fade_routine = call_when_true(
        function()
        {
            return audio_group_get_gain(audiogroup_default) == 0;
        },
        function()
        {
            play_music(nextmus);
            audio_group_set_gain(audiogroup_default, global.settings.volume_music, nexttime)
        }
    )
}

function stop_all_sounds()
{
    audio_stop_all();
    global.current_music = undefined;
    global.current_fade_routine = -1;
}