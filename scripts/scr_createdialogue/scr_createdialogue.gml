// Creates a dialogue box.
function create_dialogue(_side, _pages) {
	return instance_create_layer(0, 0, "Systems", obj_dialogue_box, {side: _side, pages: _pages});
}

// Creates a "basic" dialogue box (no portrait, automatically aligned).
function create_dialogue_basic(pages, _speaker = noone) {
	for (var i = 0; i < array_length(pages); i++) {
		pages[i] = {text: pages[i], face: undefined, blip: snd_blip_generic, speaker: _speaker}
	}
	
	return create_dialogue(undefined, pages)
}

function create_dialogue_bubble(tail_x, tail_y, _tail_side, _width, _height, _pages) {
	return instance_create_layer(tail_x, tail_y, "Systems", obj_dialogue_bubble, {
		tail_side: _tail_side,
		width: _width,
		height: _height,
		pages: _pages
	});
}