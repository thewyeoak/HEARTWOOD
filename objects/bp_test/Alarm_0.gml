var _spawn_angle = random(360)
var _dist = 100

var _dest_x = obj_heart.x + lengthdir_x(_dist, _spawn_angle)
var _dest_y = obj_heart.y + lengthdir_y(_dist, _spawn_angle)

var _margin = 32
_dest_x = clamp(_dest_x, _margin, room_width - _margin)
_dest_y = clamp(_dest_y, _margin, room_height - _margin)

var _blaster = instance_create_depth(-1000, -1000, self.depth, obj_gblaster)
with (_blaster) {
    self_target.x = _dest_x
    self_target.y = _dest_y
    target_object = obj_heart
    
    image_yscale = 0.5 // can be set to whatever 
}

alarm[0] = spawn_rate