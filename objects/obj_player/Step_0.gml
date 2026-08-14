var _dir_x = can_player_move() ? (global.keys_held.right - global.keys_held.left) : 0
var _dir_y = can_player_move() ? (global.keys_held.down - global.keys_held.up) : 0

var _movement_spd = global.keys_held.cancel and can_run ? 5 : 3

if global.debug.cheats.noclip
{
    _movement_spd = 5
}

x += _dir_x * _movement_spd

if place_meeting(x, y, obj_collision) and !global.debug.cheats.noclip
{
    x = xprevious
    
    while !place_meeting(x + sign(_dir_x), y, obj_collision) 
    {
        x += sign(_dir_x)
    }
    
    if _dir_y == 0 
    {
        repeat _movement_spd - abs(x - xprevious) 
        {
            if place_meeting(x + sign(_dir_x), y, obj_collision) 
            {
                if !place_meeting(x + sign(_dir_x), y - 1, obj_collision) 
                {
                    x += sign(_dir_x)
                    y -= 1
                } 
                else if !place_meeting(x + sign(_dir_x), y + 1, obj_collision) 
                {
                    x += sign(_dir_x)
                    y += 1
                }
            } 
            else 
            {
                x += sign(_dir_x)
            }
        }
    }
}
    
y += _dir_y * _movement_spd

if place_meeting(x, y, obj_collision) and !global.debug.cheats.noclip
{
    y = yprevious
    
    while !place_meeting(x, y + sign(_dir_y), obj_collision) 
    {
        y += sign(_dir_y)
    }
    
    if _dir_x == 0 
    {
        repeat _movement_spd - abs(y - yprevious) 
        {
            if place_meeting(x, y + sign(_dir_y), obj_collision)
            {
                if !place_meeting(x - 1, y + sign(_dir_y), obj_collision)
                {               
                    x -= 1
                    y += sign(_dir_y)
                } 
                else if !place_meeting(x + 1, y + sign(_dir_y), obj_collision)
                {
                    x += 1
                    y += sign(_dir_y)
                }
            } 
            else 
            {
                y += sign(_dir_y)
            }
        }
    }
}

if _dir_x == 0
{
    if _dir_y == -1
    {
        facing = directions.up
    } 
    else if _dir_y == 1
    {
        facing = directions.down
    }
} 
else if _dir_y == 0
{
    if _dir_x == -1
    {
        facing = directions.left
    } 
    else if _dir_x == 1
    {
        facing = directions.right
    }
} 
else 
{
    switch facing 
    {
        case directions.left:
            if _dir_x == 1 facing = directions.right
            break
        
        case directions.right:
            if _dir_x == -1 facing = directions.left
            break
        
        case directions.up:
            if _dir_y == 1 facing = directions.down
            break
        
        case directions.down:
            if _dir_y == -1 facing = directions.up
            break
    }
}

var _old_moving = moving
moving = x != xprevious or y != yprevious
var _running = moving and global.keys_held.cancel and can_run

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

if moving != _old_moving
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
    image_speed = _running ? 5 / 3 : 1
}

if (!can_interact) {
	if (can_player_move() && global.keys_pressed.confirm) {
		var _check_x1;
		var _check_y1;
		var _check_x2;
		var _check_y2;
		
		switch (facing) {
			case directions.right:
				_check_x1 = bbox_right + 1;
				_check_y1 = (bbox_top + bbox_bottom) / 2;
				_check_x2 = _check_x1 + 14;
				_check_y2 = _check_y1;
				break;
			
			case directions.up:
				_check_x1 = x;
				_check_y1 = bbox_top - 1;
				_check_x2 = _check_x1;
				_check_y2 = _check_y1 - 14;
				break;
			
			case directions.left:
				_check_x1 = bbox_left - 1;
				_check_y1 = (bbox_top + bbox_bottom) / 2;
				_check_x2 = _check_x1 - 14;
				_check_y2 = _check_y1;
				break;
			
			case directions.down:
				_check_x1 = x;
				_check_y1 = bbox_bottom + 1;
				_check_x2 = _check_x1;
				_check_y2 = _check_y1 + 14;
				break;
		}
		
		var _instance = collision_line(_check_x1, _check_y1, _check_x2, _check_y2, obj_interaction, false, false);
		if (_instance != noone) {
			if (variable_instance_exists(_instance, "require_facing")) {
				if (_instance.require_facing == facing) {
					_instance.interact();	
				}
			} else {
				_instance.interact();
			}
		}
	}
} else {
	can_interact = false;	
}

if (!can_player_move()) {
	can_interact = true;	
}

var _target_footstep = _running ? base_footstep / 2 : base_footstep

if footstep and moving 
{
    if time == 0 {
        audio_play_sound(snd_step1, 10, false)
    }
    if time == _target_footstep {
        audio_play_sound(snd_step2, 10, false)
    }
    time++
    if time >= _target_footstep * 2 {
        time = 0
    }
}