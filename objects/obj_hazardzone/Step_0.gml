if !enabled {exit}
active = place_meeting(x, y, obj_player) ? true : false

var _ease_time = 0.1
var _target = active ? 1 : 0

ease_start(obj_player.id, "outline_alpha", _target, _ease_time, easing.linear)
obj_master.fade_to(_ease_time, easing.linear, _target/3, layer_get_depth("Player"))

if (active && !instance_exists(obj_heart)) {
    var _center = -1
    with (obj_player) {
        _center = get_sprite_center()
    }
    instance_create_depth(_center.x, _center.y+4, layer_get_depth("Player")-1, obj_heart, {mode: soul_mode.overworld, image_alpha: 0})
} else if instance_exists(obj_heart) {
    ease_alpha(obj_heart.id, _target, _ease_time, easing.linear, function(){instance_destroy(obj_heart)})
}

if (active && active_pattern == noone && bullet_pattern != noone) {
    active_pattern = instance_create_depth(x, y, layer_get_depth("Systems")+1, bullet_pattern, {creator: id})
} else if (!active && active_pattern != noone) {
    instance_destroy(active_pattern)
    active_pattern = noone
}