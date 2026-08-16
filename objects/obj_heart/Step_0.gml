dir_x = can_move ? (global.keys_held.right - global.keys_held.left) : 0
dir_y = can_move ? (global.keys_held.down - global.keys_held.up) : 0

var _hit_bullet = instance_place(x, y, obj_bullet)

if (!immunity && _hit_bullet != noone) {
    if (!variable_instance_exists(_hit_bullet, "damage")) {return}
    if (_hit_bullet.damage == 0) {return}
    immunity = true
    
    var _fatal = (mode == soul_mode.overworld && global.stats.hp >= 2)
    global.stats.hp -= _hit_bullet.damage
    if (_fatal && global.stats.hp <= 0) {
        global.stats.hp = 1
    } else {
        global.stats.hp = max(0, global.stats.hp)
    }
    
    if (global.stats.hp == 0) {
        obj_hud.enabled = false
        obj_hud.anim_offset = obj_hud.total_height
        obj_master.fade_out(0, easing.linear) 
        
        var _cam = view_camera[0]
        var _cam_x = camera_get_view_x(_cam)
        var _cam_y = camera_get_view_y(_cam)
        var _cam_w = camera_get_view_width(_cam)
        var _cam_h = camera_get_view_height(_cam)
        
        var _percent_x = (x - _cam_x) / _cam_w
        var _percent_y = (y - _cam_y) / _cam_h
        
        global.death_x = _percent_x * 640
        global.death_y = _percent_y * 480
        
        var _scale_ratio = 640 / _cam_w
        global.death_scale = image_xscale * _scale_ratio
        
        global.stats.hp = global.stats.max_hp
        room_goto(rm_gameover)
        return
    }
    
    if (instance_exists(obj_camera)) {
        obj_camera.apply_shake(3, 0.5)
    }
    
    image_index = 0; image_speed = 1
    play_sfx(snd_hurt, 1)
    
    call_later(immunity_time, time_source_units_seconds, function() {
        immunity = false
        image_index = 0; image_speed = 0
    })
}