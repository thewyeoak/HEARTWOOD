if global.debug.cheats.hitboxes
{ 
    draw_self()
	
	if mode != trigger_modes.transition { exit }
	
	draw_set_halign(fa_center)
	draw_set_valign(fa_middle)
	
	var target_room = transition_target.room
	try { target_room = room_get_name(target_room) }
	catch(not_a_room) { }
	
	var text_origin = { x : x + sprite_width / 2, y : y + sprite_height / 2 }
	text_origin = fit_text_into_room(text_origin)
	
	draw_text_transformed_outline(text_origin.x,
								  text_origin.y - 4,
								  fnt_maintext, target_room,
								  0.5, 0.5, 0, #0055FF, c_black, 1)
	
	draw_text_transformed_outline(text_origin.x,
								  text_origin.y + 4,
								  fnt_maintext, transition_target.dummy_index,
								  0.5, 0.5, 0, #0055FF, c_black, 1)
	
	draw_set_halign(fa_left)
	draw_set_valign(fa_top)
}