if (global.spawn_index == index) && instance_exists(obj_player)
{
    instance_find(obj_player, 0).x = x;
    instance_find(obj_player, 0).y = y;

    instance_find(obj_player, 0).facing = facing;
} else if (global.spawn_index == index) {
    instance_create_layer(x,y,"Player",obj_player)
    
    instance_find(obj_player, 0).x = x;
    instance_find(obj_player, 0).y = y;

    instance_find(obj_player, 0).facing = facing;
}