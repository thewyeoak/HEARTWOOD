time = 0

if (!variable_instance_exists(id, "facing")) 
{
    facing = directions.down
}

sprites = 
{
    up : spr_player_up,
    down : spr_player_down,
    left : spr_player_left,
    right : spr_player_right
}

moving = undefined; footstep = true; base_footstep = 12 // base_footstep is how fast the footstep sounds should be (higher = slower)
can_interact = true; can_run = true

outline_color = c_red; outline_alpha = 0