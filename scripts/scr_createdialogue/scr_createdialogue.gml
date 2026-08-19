// Creates a dialogue box.
function create_dialogue(_side, _pages) {
	return instance_create_layer(0, 0, "Systems", obj_dialogue_box, {side: _side, pages: _pages, draw_box: true})
}

// Creates a "basic" dialogue box (no portrait, automatically aligned).
function create_dialogue_basic(pages, _speaker = noone) {
	for (var i = 0; i < array_length(pages); i++) {
		pages[i] = {text: pages[i], face: undefined, blip: snd_blip_generic, speaker: _speaker}
	}
	
	return create_dialogue(undefined, pages)
}

// Creates a boxless dialogue positioned at an exact point, e.g. for cutscene narration.
function create_dialogue_at(_x, _y, _pages) {
	return instance_create_layer(_x, _y, "Systems", obj_dialogue_box, {pages: _pages, draw_box: false})
}

function create_dialogue_choice(_side, _text, _choices, _inputs = undefined, _on_choice = undefined, _speaker = noone) {
	if (is_undefined(_inputs)) _inputs = default_choice_inputs(array_length(_choices))
	
	var _page = {
		text: _text,
        add_asterisks: false,
		face: undefined,
		blip: snd_blip_generic,
		speaker: _speaker,
		choices: _choices,
		choice_inputs: _inputs,
		on_choice: _on_choice
	}
	
	return create_dialogue(_side, [_page])
}

function create_dialogue_bubble(tail_x, tail_y, _tail_side, _width, _height, _pages) {
	return instance_create_layer(tail_x, tail_y, "Systems", obj_dialogue_bubble, {
		tail_side: _tail_side,
		width: _width,
		height: _height,
		pages: _pages
	});
}

function create_dialogue_choice_only(_side, _choices, _callback) {
	return create_dialogue_choice(_side, "", _choices, default_choice_inputs(array_length(_choices)), _callback)
}

function dialogue_box_geometry(_side) {
	var _geo = {}
	
	if global.dark {
		_geo.box_margin_w = 32 - 8
		_geo.box_width = 593
		_geo.box_height = 167
		_geo.vertical_margin = 28
		_geo.horizontal_margin = 40
		_geo.sprite_index = spr_darkbox
		
		// Get position of the top of the box
		_geo.rect_y = (_side == directions.up) ? 10 : 311
	} else {
		_geo.box_margin_w = 32
		_geo.box_width = 578
		_geo.box_height = 152
		_geo.vertical_margin = 21
		_geo.horizontal_margin = 28
		_geo.sprite_index = spr_textbox
		_geo.rect_y = (_side == directions.up) ? 10 : 320
	}
	
	return _geo
}