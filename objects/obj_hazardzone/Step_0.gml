if (!enabled) {exit}

active = place_meeting(x, y, obj_player) ? true : false
var _ease_time = 0.2
var _target = active ? 1 : 0

if (active != prev_active) {
    ease_start(obj_player.id, "outline_alpha", _target, _ease_time, easing.linear)
    obj_master.fade_to(_ease_time, easing.linear, _target/3, layer_get_depth("Player"))
    obj_player.image_blend = merge_color(c_white, c_black, _target/2)
    obj_hud.enabled = active
    
    if (active) {
        if (!instance_exists(obj_heart)) {
            var _center = -1
            with (obj_player) {
                _center = get_sprite_center()
            }
            instance_create_depth(_center.x, _center.y+4, layer_get_depth("Player")-1, obj_heart, {mode: soul_mode.overworld, image_alpha: 0})
        }
        
        ease_alpha(obj_heart.id, 1, _ease_time, easing.linear)
        
    } else {
        if (instance_exists(obj_heart)) {
            ease_alpha(obj_heart.id, 0, _ease_time, easing.linear, function() {instance_destroy(obj_heart)})
        }
    }
}

prev_active = active

if (active && active_pattern == noone && bullet_pattern != noone) {
    active_pattern = instance_create_depth(x, y, layer_get_depth("Systems")+1, bullet_pattern, {creator: id})
} else if (!active && active_pattern != noone) {
    instance_destroy(active_pattern)
    active_pattern = noone
}