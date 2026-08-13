if !enabled {exit}
active = place_meeting(x, y, obj_player) ? true : false

var _target = active ? 1 : 0
ease_start(obj_player.id, "outline_alpha", _target, 0.2, easing.linear)
obj_master.fade_to(0.2, easing.linear, _target/3, layer_get_depth("Player"))