active = false
prev_active = false
enabled = true

active_pattern = noone

transition_time = 0.2

world_dim = 1/3
player_dim = 1/2

enter_zone = function() {
    ease_start(obj_player.id, "outline_alpha", 1, transition_time, easing.linear)
    obj_master.fade_to(transition_time, easing.linear, world_dim, layer_get_depth("Player"))
    ease_start(obj_player.id, "tint", -player_dim, transition_time, easing.linear)
    obj_hud.enabled = true

    if (!instance_exists(obj_heart)) {
        var _center = instance_sprite_center(obj_player)

        instance_create_depth(_center.x, _center.y + 4, layer_get_depth("Player") - 1, obj_heart, {mode: soul_mode.overworld, image_alpha: 0})
    }

    ease_alpha(obj_heart.id, 1, transition_time, easing.linear)
}

exit_zone = function() {
    ease_start(obj_player.id, "outline_alpha", 0, transition_time, easing.linear)
    obj_master.fade_to(transition_time, easing.linear, 0, layer_get_depth("Player"))
    ease_start(obj_player.id, "tint", 0, transition_time, easing.linear)
    obj_hud.enabled = false

    if (instance_exists(obj_heart)) {
        ease_alpha(obj_heart.id, 0, transition_time, easing.linear, function() {instance_destroy(obj_heart)})
    }
}