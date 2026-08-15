if (!initialized) {
    if (!is_undefined(target_object) && instance_exists(target_object)) {
        target.x = target_object.x
        target.y = target_object.y
    }
    
    target_angle = point_direction(self_target.x, self_target.y, target.x, target.y)
    image_angle = target_angle + 180
    
    var _dist_left = self_target.x
    var _dist_right = room_width - self_target.x
    var _dist_top = self_target.y
    var _dist_bottom = room_height - self_target.y
    
    var _nearest_edge = min(_dist_left, _dist_right, _dist_top, _dist_bottom)
    var _pad = 50
    
    if (_nearest_edge == _dist_left) {
        x = -_pad
        y = self_target.y
    } else if (_nearest_edge == _dist_right) {
        x = room_width + _pad
        y = self_target.y
    } else if (_nearest_edge == _dist_top) {
        x = self_target.x
        y = -_pad
    } else {
        x = self_target.x
        y = room_height + _pad
    }
    
    initialized = true
    audio_play_sound(snd_blastercharge, 2, false)
    alarm[0] = fire_delay
}

if (state == "idle" || state == "charge") {
    x = lerp(x, self_target.x, 0.2); y = lerp(y, self_target.y, 0.2)
    target_angle = point_direction(x, y, target.x, target.y)
    
    var _angle_diff = angle_difference(target_angle, image_angle)
    image_angle += _angle_diff * 0.2
}

switch (state) {
    case "idle":
        image_index = 0
    break
        
    case "charge":
        if (image_index >= 4) {
            state = "recoil"
          
            var _beam = instance_create_depth(x, y, self.depth+1, obj_gblasterbeam)
            audio_play_sound(snd_blasterfire, 2, false)
            
            _beam.image_angle = image_angle
            _beam.creator = id
            _beam.max_thickness = image_yscale * 3
            _beam.damage = damage
            
            if (instance_exists(obj_camera)) {
                obj_camera.apply_shake(1, 0.25)
            }
            
            recoil_x = x - lengthdir_x(1000, image_angle)
            recoil_y = y - lengthdir_y(1000, image_angle)
        }
    break
        
    case "recoil":
        if (image_index < 4) {
            image_index = 4
        }
        
        x = lerp(x, recoil_x, 0.01)
        y = lerp(y, recoil_y, 0.01)
        
        if (point_distance(x, y, self_target.x, self_target.y) > 800) {
            instance_destroy()
        }
    break
}