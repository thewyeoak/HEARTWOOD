face_text_offset = 116

if draw_box {
	// Automatically find box side based on player position (if it's not already defined)
	if (is_undefined(side)) {
		side = (obj_player.y - 26 - camera_get_view_y(view_camera[0]) > 120 ? directions.up : directions.down)
	}
	
	var _geo = dialogue_box_geometry(side)
	box_margin_w = _geo.box_margin_w
	box_width = _geo.box_width
	box_height = _geo.box_height
	vertical_margin = _geo.vertical_margin
	horizontal_margin = _geo.horizontal_margin
	sprite_index = _geo.sprite_index
	rect_y = _geo.rect_y
	
	// The "div 4 * 2"s ensure we keep to the double pixel grid used in the overworld
	face_offset_w = 6 + (horizontal_margin + face_text_offset - 6) div 4 * 2
	face_offset_h = box_height div 4 * 2 - 1
	
	text_x = box_margin_w + horizontal_margin
	text_x_with_face = box_margin_w + horizontal_margin + face_text_offset
	text_y = rect_y + vertical_margin
} else {
	text_x = x
	text_x_with_face = x
	text_y = y
}

pages_length = array_length(pages)
current_page = 0

_typewriter = page_typewriter(pages[current_page])
_choice_selector = noone

// This is incremented every frame, so to prevent the first talk sprite only appearing for three frames we have to set this to -1.
face_talk_counter = -1