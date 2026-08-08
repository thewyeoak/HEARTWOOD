draw_sprite_stretched(sprite_index, image_index, box_margin_w, rect_y, box_width, box_height)

if (!is_undefined(pages[current_page].face)) {
	draw_sprite_ext(
		(
			(
				pages[current_page].face.talk_sprite == noone
				|| _typewriter.shown_chars == _typewriter.text_length && face_talk_counter % 8 < 4
				|| ++face_talk_counter % 8 < 4
			)
			? pages[current_page].face.sprite
			: pages[current_page].face.talk_sprite
		),
		pages[current_page].face.image,
		box_margin_w + face_offset_w,
		rect_y + face_offset_h,
		2, 2, 0, c_white, 1
	);
}

_typewriter.draw(is_undefined(pages[current_page].face) ? text_x : text_x_with_face, text_y);