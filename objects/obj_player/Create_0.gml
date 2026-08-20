time = 0
if (!variable_instance_exists(id, "facing")) {
    facing = directions.down
}

sprites = [spr_player_up, spr_player_down, spr_player_left, spr_player_right]

moving = undefined
footstep = true
base_footstep = 12 // base_footstep is how fast the footstep sounds should be (higher = slower)

walk_speed = 3
run_speed = 5
can_run = true

// how far in front of the player we look for something to interact with
interact_reach = 14
// prevents the z press from closing a dialogue initiating another dialogue
swallow_interact = false

outline_color = c_red
outline_alpha = 0
tint = 0

try_interact = function() {
    var _from_x, _from_y, _reach_x, _reach_y

    switch (facing) {
        case directions.right:
            _from_x = bbox_right + 1
            _from_y = (bbox_top + bbox_bottom) / 2
            _reach_x = interact_reach
            _reach_y = 0
            break

        case directions.up:
            _from_x = x
            _from_y = bbox_top - 1
            _reach_x = 0
            _reach_y = -interact_reach
            break

        case directions.left:
            _from_x = bbox_left - 1
            _from_y = (bbox_top + bbox_bottom) / 2
            _reach_x = -interact_reach
            _reach_y = 0
            break

        case directions.down:
            _from_x = x
            _from_y = bbox_bottom + 1
            _reach_x = 0
            _reach_y = interact_reach
            break
    }

    var _instance = collision_line(_from_x, _from_y, _from_x + _reach_x, _from_y + _reach_y, obj_interaction, false, false)
    if (_instance == noone) {return}

    if (variable_instance_exists(_instance, "require_facing") && _instance.require_facing != facing) {return}

    _instance.interact()
}