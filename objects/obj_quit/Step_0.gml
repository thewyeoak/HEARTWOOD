scale = global.max_scale_integer / 2

if (!global.keys_held.escape) {
    image_alpha = 0; image_index = 0; time = 0
    ease_cancel(id, "image_alpha"); exit
}

if (++time == 30) 
{
    game_end();	
}

image_index = time/10