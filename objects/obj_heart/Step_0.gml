dir_x = can_move ? (global.keys_held.right - global.keys_held.left) : 0
dir_y = can_move ? (global.keys_held.down - global.keys_held.up) : 0

var _hit_bullet = instance_place(x, y, obj_bullet)

if (!immunity && _hit_bullet != noone) {
    if (!variable_instance_exists(_hit_bullet, "damage")) {return}
    if (_hit_bullet.damage == 0) {return}
    immunity = true
    
    global.stats.hp -= _hit_bullet.damage
    global.stats.hp = max(0, global.stats.hp)
    
    if (instance_exists(obj_camera)) {
        obj_camera.apply_shake(3, 0.5)
    }
    
    image_index = 0; image_speed = 1
    audio_play_sound(snd_hurt, 10, false)
    
    call_later(immunity_time, time_source_units_seconds, function() {
        immunity = false
        image_index = 0; image_speed = 0
    })
}