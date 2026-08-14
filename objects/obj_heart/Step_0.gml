dir_x = can_move ? (global.keys_held.right - global.keys_held.left) : 0
dir_y = can_move ? (global.keys_held.down - global.keys_held.up) : 0

if (!immunity && place_meeting(x, y, obj_bullet)) {
    immunity = true
    image_index = 0; image_speed = 1
    audio_play_sound(snd_hurt, 10, false)
    
    call_later(immunity_time, time_source_units_seconds, function() {
        immunity = false
        image_index = 0; image_speed = 0
    })
}