sprite_index = spr_trigger_hollow

transition_fade_time = 0.5
fade_depth = -100

function transition_behavior()
{
	obj_master.transition_to(transition_target, transition_fade_time, fade_depth)
}

function battle_behavior()
{
// later
}

function fit_text_into_room(_text_origin)
{
	var output = _text_origin
	if output.x > room_width
	{
		draw_set_halign(fa_right)
		output.x = room_width - 10
	}
	if output.x < 0
	{
		draw_set_halign(fa_left)
		output.x = 10
	}

	if output.y > room_height
	{
		draw_set_valign(fa_bottom)
		output.y = room_height - 10
	}
	if output.y < 0
	{
		draw_set_valign(fa_top)
		output.y = 10
	}

	return output
}