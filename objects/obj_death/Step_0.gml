if (global.keys_pressed.confirm && can_proceed) {
    fade_music(noone, 2)
    ease_start(id, "gameover_alpha", 0, 2, easing.inout_sine, function(){
        call_later(1, time_source_units_seconds, function(){
            room_goto(global.current_file.save_location)
        })
    })
}