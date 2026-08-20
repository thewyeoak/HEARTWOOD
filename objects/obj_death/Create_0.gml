image_speed = 0
x = global.death_x
y = global.death_y
image_xscale = global.death_scale
image_yscale = global.death_scale

gameover_alpha = 0
visible_heart = true
can_proceed = false

var _gameover_text = struct_merge_into(format_gameover, {
    line_length: 24,
    add_asterisks: false,
    blip: snd_blip_battle
})

var _death_cuts = cutscene_create()
    ._then(new ev_delay(.6))
    ._then(new ev_execute_script(function() {
        sprite_index = spr_heartbreak
        play_sfx(snd_heartbreak, 1)
    }))
    ._then(new ev_delay(1.6))
    ._then(new ev_execute_script(function() {
        visible_heart = false
        play_sfx(snd_heartshatter, 1)

        instance_create_depth(x-2, y, depth, obj_heartshard)
        instance_create_depth(x, y+3, depth, obj_heartshard)
        instance_create_depth(x+2, y+6, depth, obj_heartshard)
        instance_create_depth(x+8, y, depth, obj_heartshard)
        instance_create_depth(x+10, y+3, depth, obj_heartshard)
        instance_create_depth(x+12, y+6, depth, obj_heartshard)
    }))
    ._then(new ev_delay(1.6))
    ._then(new ev_execute_script(function() {
        play_music(mus_gameover)
        ease_start(id, "gameover_alpha", 1, 2, easing.inout_sine)
    }))
    ._then(new ev_delay(1.6))
    ._then(new ev_typewriter(100, 300, "You are dead, not big surprise.", _gameover_text))
    ._then(new ev_typewriter(100, 300, "Uhhhh... What's your name again? " + global.current_file.player_name + "?", _gameover_text))
    ._then(new ev_typewriter(100, 300, "That's dumb. Get a new name.", _gameover_text))
    ._then(new ev_execute_script(function() {
        can_proceed = true
    }))
cutscene_start(_death_cuts)