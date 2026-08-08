var dir_x = 0
var dir_y = 0

if can_player_move()
{
    dir_x = global.keys_held.right - global.keys_held.left
    dir_y = global.keys_held.down - global.keys_held.up
}

var movement_spd = global.keys_held.cancel and can_run ? 5 : 3

if global.debug.cheats.noclip
{
    movement_spd = 5
}

x += dir_x * movement_spd

if place_meeting(x, y, obj_collision) and !global.debug.cheats.noclip
{
    x = xprevious
    
    while !place_meeting(x + sign(dir_x), y, obj_collision) 
    {
        x += sign(dir_x)
    }
    
    if dir_y == 0 
    {
        repeat movement_spd - abs(x - xprevious) 
        {
            if place_meeting(x + sign(dir_x), y, obj_collision) 
            {
                if !place_meeting(x + sign(dir_x), y - 1, obj_collision) 
                {
                    x += sign(dir_x)
                    y -= 1
                } 
                else if !place_meeting(x + sign(dir_x), y + 1, obj_collision) 
                {
                    x += sign(dir_x)
                    y += 1
                }
            } 
            else 
            {
                x += sign(dir_x)
            }
        }
    }
}
    
y += dir_y * movement_spd

if place_meeting(x, y, obj_collision) and !global.debug.cheats.noclip
{
    y = yprevious
    
    while !place_meeting(x, y + sign(dir_y), obj_collision) 
    {
        y += sign(dir_y)
    }
    
    if dir_x == 0 
    {
        repeat movement_spd - abs(y - yprevious) 
        {
            if place_meeting(x, y + sign(dir_y), obj_collision)
            {
                if !place_meeting(x - 1, y + sign(dir_y), obj_collision)
                {               
                    x -= 1
                    y += sign(dir_y)
                } 
                else if !place_meeting(x + 1, y + sign(dir_y), obj_collision)
                {
                    x += 1
                    y += sign(dir_y)
                }
            } 
            else 
            {
                y += sign(dir_y)
            }
        }
    }
}

if dir_x == 0
{
    if dir_y == -1
    {
        facing = directions.up
    } 
    else if dir_y == 1
    {
        facing = directions.down
    }
} 
else if dir_y == 0
{
    if dir_x == -1
    {
        facing = directions.left
    } 
    else if dir_x == 1
    {
        facing = directions.right
    }
} 
else 
{
    switch facing 
    {
        case directions.left:
            if dir_x == 1 facing = directions.right
            break
        
        case directions.right:
            if dir_x == -1 facing = directions.left
            break
        
        case directions.up:
            if dir_y == 1 facing = directions.down
            break
        
        case directions.down:
            if dir_y == -1 facing = directions.up
            break
    }
}

var old_moving = moving
moving = x != xprevious or y != yprevious
var running = moving and global.keys_held.cancel and can_run

switch facing 
{
    case directions.right: 
        sprite_index = sprites.right
        break
    
    case directions.up: 
        sprite_index = sprites.up
        break
    
    case directions.left: 
        sprite_index = sprites.left
        break
    
    case directions.down: 
        sprite_index = sprites.down
        break
}

if moving != old_moving
{
    if moving
    {
        image_index = 1
    } 
    else 
    {
        image_index = 0
        image_speed = 0
        time = 0
    }
}

if moving
{
    image_speed = running ? 5 / 3 : 1
}

if (!can_interact) {
	if (can_player_move() && global.keys_pressed.confirm) {
		var check_x1;
		var check_y1;
		var check_x2;
		var check_y2;
		
		switch (facing) {
			case directions.right:
				check_x1 = bbox_right + 1;
				check_y1 = (bbox_top + bbox_bottom) / 2;
				check_x2 = check_x1 + 14;
				check_y2 = check_y1;
				break;
			
			case directions.up:
				check_x1 = x;
				check_y1 = bbox_top - 1;
				check_x2 = check_x1;
				check_y2 = check_y1 - 14;
				break;
			
			case directions.left:
				check_x1 = bbox_left - 1;
				check_y1 = (bbox_top + bbox_bottom) / 2;
				check_x2 = check_x1 - 14;
				check_y2 = check_y1;
				break;
			
			case directions.down:
				check_x1 = x;
				check_y1 = bbox_bottom + 1;
				check_x2 = check_x1;
				check_y2 = check_y1 + 14;
				break;
		}
		
		var instance = collision_line(check_x1, check_y1, check_x2, check_y2, obj_interaction, false, false);
		if (instance != noone) {
			if (variable_instance_exists(instance, "require_facing")) {
				if (instance.require_facing == facing) {
					instance.interact();	
				}
			} else {
				instance.interact();
			}
		}
	}
} else {
	can_interact = false;	
}

if (!can_player_move()) {
	can_interact = true;	
}

var target_footstep = running ? base_footstep / 2 : base_footstep

if footstep and moving 
{
    if time == 0 
    {
        audio_play_sound(snd_step1, 10, false)
    }
    if time == target_footstep 
    {
        audio_play_sound(snd_step2, 10, false)
    }
    time++
    if time >= target_footstep * 2 
    {
        time = 0
    }
}