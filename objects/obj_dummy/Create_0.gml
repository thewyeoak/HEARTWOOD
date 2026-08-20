spawn_facing = directions.keep

switch sprite_index
{
	case spr_dummy_down:
	spawn_facing = directions.down
	break
	
	case spr_dummy_up:
	spawn_facing = directions.up
	break
	
	case spr_dummy_left:
	spawn_facing = directions.left
	break
	
	case spr_dummy_right:
	spawn_facing = directions.right
	break
}

if ignore_sprite { spawn_facing = directions.keep }

index = image_index

function update_dummy()
{
	if (global.spawn_index != index) { exit }

	if !instance_exists(obj_player)
	{
		instance_create_layer(x,y,"Player",obj_player)
	}
	
	var player = instance_find(obj_player, 0)
	
	player.x = x
	player.y = y
	
	player.xprevious = x
	player.yprevious = y
	
	if spawn_facing == directions.keep { exit }
	
	player.facing = spawn_facing
}

update_dummy()