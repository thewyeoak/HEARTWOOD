//if !global.debug.cheats.hitboxes { exit }
//if mode != trigger_modes.transition { exit }
	
//draw_set_halign(fa_center)
//draw_set_valign(fa_middle)
	
//var target_room = transition_target.room
//try { target_room = room_get_name(target_room) }
//catch(not_a_room) { }
	
// var text_origin =
//{ 
//	x : (x + sprite_width / 2), 
//	y : (y + sprite_height / 2)
//}
//text_origin = fit_text_into_room(text_origin)

//var real_scale = global.draw_scale * 2
//draw_text_transformed_outline((text_origin.x - CAM_X) * real_scale, 
//								(text_origin.y - 4 - CAM_Y) * real_scale,
// fnt_maintext, target_room,
// 0.5 * real_scale, 0.5 * real_scale, 0, #0055FF, c_black, 1)
	
//draw_text_transformed_outline((text_origin.x - CAM_X) * real_scale,
//								(text_origin.y + 4 - CAM_Y) * real_scale,
// fnt_maintext, transition_target.dummy_index,
// 0.5 * real_scale, 0.5 * real_scale, 0, #0055FF, c_black, 1)
	
//draw_set_halign(fa_left)
//draw_set_valign(fa_top)