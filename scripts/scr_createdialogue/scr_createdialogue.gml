// creates a dialogue page; anything left out is filled in later by the presenter and the base defaults
function dialogue_page(_text, _opts = {}) {
	var _page = struct_merge_into({}, _opts)
	_page.text = _text

	return _page
}

// creates the portrait half of a page
function dialogue_face(_sprite, _talk_sprite = noone, _image = 0) {
	return {
		sprite: _sprite,
		talk_sprite: _talk_sprite,
		image: _image
	}
}

// turns an array that may contain plain strings into an array of pages
function dialogue_pages_from(_pages, _opts = {}) {
	var _built = array_create(array_length(_pages))

	for (var i = 0; i < array_length(_pages); i++) {
		if (is_string(_pages[i])) {
			_built[i] = dialogue_page(_pages[i], _opts)
		} else {
			_built[i] = struct_merge_into(struct_merge_into({}, _opts), _pages[i])
		}
	}

	return _built
}

// fills in everything a page left out, first from the presenter's defaults and then from the base ones
function dialogue_page_resolve(_page, _defaults = {}) {
	static base = {
		face: undefined,
		blip: snd_blip_generic,
		speaker: noone,
		pitch_low: 1,
		pitch_high: 1,
		font: fnt_main,
		char_spacing: 16,
		line_spacing: 36,
		line_length: 32,
		add_asterisks: true,
		can_skip: true,
		choices: undefined,
		choice_inputs: undefined,
		on_choice: undefined
	}

	var _resolved = struct_merge_into({}, base)
	struct_merge_into(_resolved, _defaults)
	struct_merge_into(_resolved, _page)

	return _resolved
}

// creates a dialogue box
function create_dialogue(_side, _pages) {
	return instance_create_layer(0, 0, "Systems", obj_dialogue, {presenter: new presenter_box(_side), pages: dialogue_pages_from(_pages)})
}

// creates a "basic" dialogue box (no portrait, automatically aligned)
function create_dialogue_basic(_pages, _speaker = noone) {
	return create_dialogue(undefined, dialogue_pages_from(_pages, {speaker: _speaker}))
}

// creates a boxless dialogue positioned at an exact point, e.g. for cutscene narration
function create_dialogue_at(_x, _y, _pages) {
	return instance_create_layer(_x, _y, "Systems", obj_dialogue, {presenter: new presenter_bare(_x, _y), pages: dialogue_pages_from(_pages)})
}

function create_dialogue_choice(_side, _text, _choices, _inputs = undefined, _on_choice = undefined, _speaker = noone) {
	if (is_undefined(_inputs)) _inputs = default_choice_inputs(array_length(_choices))

	var _page = dialogue_page(_text, {
		add_asterisks: false,
		speaker: _speaker,
		choices: _choices,
		choice_inputs: _inputs,
		on_choice: _on_choice
	})

	return create_dialogue(_side, [_page])
}

function create_dialogue_choice_only(_side, _choices, _callback) {
	return create_dialogue_choice(_side, "", _choices, default_choice_inputs(array_length(_choices)), _callback)
}

// creates a speech bubble whose tail tip sits at the given point
function create_dialogue_bubble(_tail_x, _tail_y, _tail_side, _width, _height, _pages) {
	return instance_create_layer(_tail_x, _tail_y, "Systems", obj_dialogue, {
		presenter: new presenter_bubble(_tail_x, _tail_y, _tail_side, _width, _height),
		pages: dialogue_pages_from(_pages)
	})
}

// creates the text line used by battle dialogue
function create_dialogue_battle(_pages) {
	return instance_create_layer(0, 0, "Systems", obj_dialogue, {presenter: new presenter_battle(), pages: dialogue_pages_from(_pages)})
}

// basically just defining how the box looks
function dialogue_presenter() constructor {
	text_x = 0
	text_y = 0
	page_defaults = {}

	static initialize = function() {}
	// static stack
	static defaults_for = function(_page) {return page_defaults}
	static page_changed = function(_page) {}
	static step = function(_page, _typing) {}
	static draw_background = function(_page) {}
	static make_choice_selector = function(_choices, _inputs) {return noone}
	static cleanup = function() {}
}

// standard textbox with portrait
function presenter_box(_side = undefined) : dialogue_presenter() constructor {
	side = _side
	face_text_offset = 116
	face_talk_counter = 0

	static initialize = function() {
		if (is_undefined(side)) {
			side = (obj_player.y - 26 - camera_get_view_y(view_camera[0]) > 120 ? directions.up : directions.down)
		}

		var _geo = dialogue_box_geometry(side)
		box_margin_w = _geo.box_margin_w
		box_width = _geo.box_width
		box_height = _geo.box_height
		vertical_margin = _geo.vertical_margin
		horizontal_margin = _geo.horizontal_margin
		box_sprite = _geo.sprite_index
		rect_y = _geo.rect_y

		face_offset_w = 6 + (horizontal_margin + face_text_offset - 6) div 4 * 2
		face_offset_h = box_height div 4 * 2 - 1

		text_y = rect_y + vertical_margin
	}

	static defaults_for = function(_page) {
		page_defaults.line_length = is_undefined(_page[$ "face"]) ? 32 : 25
		return page_defaults
	}

	static page_changed = function(_page) {
		text_x = box_margin_w + horizontal_margin + (is_undefined(_page.face) ? 0 : face_text_offset)
		face_talk_counter = 0
	}

	static step = function(_page, _typing) {
		face_talk_counter = _typing ? face_talk_counter + 1 : 0
	}

	static draw_background = function(_page) {
		draw_sprite_stretched(box_sprite, 0, box_margin_w, rect_y, box_width, box_height)

		if (is_undefined(_page.face)) {return}

		var _talking = _page.face.talk_sprite != noone && face_talk_counter % 8 >= 4

		draw_sprite_ext(
			_talking ? _page.face.talk_sprite : _page.face.sprite,
			_page.face.image,
			box_margin_w + face_offset_w,
			rect_y + face_offset_h,
			2, 2, 0, c_white, 1
		)
	}

	static make_choice_selector = function(_choices, _inputs) {
		return new choice_selector(_choices, _inputs, fnt_main, 32, box_margin_w, rect_y, box_width, box_height, horizontal_margin)
	}
}

// boxless text drawn at an exact point
function presenter_bare(_x, _y) : dialogue_presenter() constructor {
	text_x = _x
	text_y = _y
}

// the battle text line, drawn at a fixed spot with no box behind it
function presenter_battle() : dialogue_presenter() constructor {
	text_x = 52
	text_y = 271
	page_defaults = struct_merge_into(format_battle, {line_length: 32, blip: snd_blip_battle})
}

// an overworld speech bubble with a tail pointing back at whoever is talking
function presenter_bubble(_x, _y, _tail_side, _width, _height) : dialogue_presenter() constructor {
	tail_side = _tail_side
	width = _width
	height = _height
	surface = -1

	page_defaults = struct_merge_into(format_bubble, {line_length: _width, add_asterisks: false})

	pixel_width = 9 * width + 15
	pixel_height = 20 * height + 24

	box_x = _x
	box_y = _y

	switch (tail_side) {
		case directions.right:
			box_x -= pixel_width + 11
			box_y -= pixel_height / 2
			break

		case directions.up:
			box_x -= pixel_width / 2
			box_y += 12
			break

		case directions.left:
			box_x += 12
			box_y -= pixel_height / 2
			break

		case directions.down:
			box_x -= pixel_width / 2
			box_y -= pixel_height + 11
			break
	}

	text_x = box_x + 7
	text_y = box_y + 12

	static page_changed = function(_page) {
		// white text is invisible in these bubbles, so it has to be black by default
		_page.text = "{c,bk}" + _page.text
	}

	static draw_background = function(_page) {
		surface = surface_ensure(surface, pixel_width + 24, pixel_height + 24)

		surface_set_target(surface)
		draw_clear_alpha(c_black, 0)

		// draw rounded corners
		draw_sprite(spr_dialogue_bubble_corner, 0, 13, 13)
		draw_sprite_ext(spr_dialogue_bubble_corner, 0, 13, pixel_height + 11, 1, 1, 90, c_white, 1)
		draw_sprite_ext(spr_dialogue_bubble_corner, 0, pixel_width + 11, pixel_height + 11, 1, 1, 180, c_white, 1)
		draw_sprite_ext(spr_dialogue_bubble_corner, 0, pixel_width + 11, 13, 1, 1, 270, c_white, 1)

		// draw middle (this is probably faster than doing it in 5 rectangles without overlap?)
		draw_rectangle(12, 26, pixel_width + 11, pixel_height - 3, false)
		draw_rectangle(26, 12, pixel_width - 3, pixel_height + 11, false)

		// draw tail on correct side
		switch (tail_side) {
			case directions.right:
				draw_sprite_ext(spr_dialogue_bubble_tail, 0, pixel_width + 12, pixel_height div 2 + 12, -1, 1, 0, c_white, 1)
				break

			case directions.up:
				draw_sprite_ext(spr_dialogue_bubble_tail, 0, pixel_width div 2 + 12, 12, 1, 1, 270, c_white, 1)
				break

			case directions.left:
				draw_sprite(spr_dialogue_bubble_tail, 0, 12, pixel_height div 2 + 12)
				break

			case directions.down:
				draw_sprite_ext(spr_dialogue_bubble_tail, 0, pixel_width div 2 + 12, pixel_height + 12, 1, 1, 90, c_white, 1)
				break
		}

		surface_reset_target()

		draw_surface_ext(surface, box_x - 13, box_y - 12, 1, 1, 0, c_black, 1)
		draw_surface_ext(surface, box_x - 11, box_y - 12, 1, 1, 0, c_black, 1)
		draw_surface_ext(surface, box_x - 12, box_y - 13, 1, 1, 0, c_black, 1)
		draw_surface_ext(surface, box_x - 12, box_y - 11, 1, 1, 0, c_black, 1)
		draw_surface(surface, box_x - 12, box_y - 12)
	}

	static cleanup = function() {
		if (surface_exists(surface)) {surface_free(surface)}
	}
}

function dialogue_box_geometry(_side) {
	static light = {
		box_margin_w: 32,
		box_width: 578,
		box_height: 152,
		vertical_margin: 21,
		horizontal_margin: 28,
		sprite_index: spr_textbox,
		top_y: 10,
		bottom_y: 320
	}

	static dark = {
		box_margin_w: 32 - 8,
		box_width: 593,
		box_height: 167,
		vertical_margin: 28,
		horizontal_margin: 40,
		sprite_index: spr_darkbox,
		top_y: 10,
		bottom_y: 311
	}

	var _geo = variable_clone(global.dark ? dark : light)
	_geo.rect_y = (_side == directions.up) ? _geo.top_y : _geo.bottom_y // get position of the top of the box

	return _geo
}