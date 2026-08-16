image_speed = 0
x = global.death_x
y = global.death_y
image_xscale = global.death_scale
image_yscale = global.death_scale

gameover_alpha = 0
visible_heart = true
can_proceed = false

var _death_cuts = cutscene_create()
    .add_events([
        new ev_delay(.6)
    ])
    .add_events([
        new ev_execute_script(function() {
            sprite_index = spr_heartbreak
            play_sfx(snd_heartbreak, 1)
        })
    ])
    .add_events([
        new ev_delay(1.6)
    ])
    .add_events([
        new ev_execute_script(function() {
            visible_heart = false
            play_sfx(snd_heartshatter, 1)
            
            instance_create_depth(x-2, y, depth, obj_heartshard)
            instance_create_depth(x, y+3, depth, obj_heartshard)
            instance_create_depth(x+2, y+6, depth, obj_heartshard)
            instance_create_depth(x+8, y, depth, obj_heartshard)
            instance_create_depth(x+10, y+3, depth, obj_heartshard)
            instance_create_depth(x+12, y+6, depth, obj_heartshard)
        })
    ])
    .add_events([
        new ev_delay(1.6)
    ])
    .add_events([
        new ev_execute_script(function() {
            play_music(mus_gameover)
            ease_start(id, "gameover_alpha", 1, 2, easing.inout_sine)
        })
    ])
    .add_events([
        new ev_delay(1.6)
    ])
    .add_events([
        new ev_typewriter(100, 300, format_gameover, 24, false, snd_blip_battle, true, noone, "You are dead, not big surprise.") 
    ])
    .add_events([
        new ev_typewriter(100, 300, format_gameover, 24, false, snd_blip_battle, true, noone, "Uhhhh... What's your name again? " + global.current_file.player_name + "?") 
    ])
    .add_events([
        new ev_typewriter(100, 300, format_gameover, 24, false, snd_blip_battle, true, noone, "That's dumb. Get a new name.") 
    ])
    .add_events([
        new ev_execute_script(function() { 
            can_proceed = true
        })
    ])
cutscene_start(_death_cuts)