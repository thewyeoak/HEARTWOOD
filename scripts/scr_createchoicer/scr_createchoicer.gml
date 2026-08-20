function default_choice_inputs(_count) {
	switch _count {
		case 1: return [directions.up]
		case 2: return [directions.left, directions.right]
		case 3: return [directions.up, directions.left, directions.right]
		case 4: return [directions.up, directions.left, directions.right, directions.down]
	}

	return []
}

function choice_selector(_choices, _inputs, _font, _line_spacing, _box_x, _box_y, _box_width, _box_height, _margin) constructor {
	choices = _choices
	inputs = _inputs
	count = array_length(choices)
	font = _font
	line_spacing = _line_spacing

	box_x = _box_x
	box_y = _box_y
	box_width = _box_width
	box_height = _box_height
	margin = _margin

	selected = -1
	confirmed = false

	// columns are placed relative to the centre of the box so both the light and dark boxes line up
	v_padding = 8
	center_gap = 110
	col_width = 120
	right_offset = 30
	side_inset = 20
	heart_offset = 14

	static index_of = function(_direction) {
		for (var i = 0; i < count; i++) {
			if inputs[i] == _direction return i
		}

		return -1
	}

	// needs the font set so it measures text itself
	static layout = function() {
		var _previous_font = draw_get_font()
		draw_set_font(font)

		var _center_x = box_x + box_width / 2
		var _center_y = box_y + box_height / 2

		var _left_x = _center_x - center_gap - col_width
		var _right_x = _center_x + center_gap + right_offset

		var _side_width = _center_x - _left_x - side_inset
		var _center_width = box_width - margin * 2

		x = _center_x
		y = _center_y

		text = array_create(count)
		positions_x = array_create(count)
		positions_y = array_create(count)
		wrap_width = array_create(count)
		heart_x = array_create(count)

		for (var i = 0; i < count; i++) {
			text[i] = choices[i]

			var _line_end = string_pos("\n", text[i])
			var _line1 = (_line_end == 0) ? text[i] : string_copy(text[i], 1, _line_end - 1)
			var _line1_width = string_width(_line1)

			switch inputs[i] {
				case directions.up:
					positions_x[i] = _center_x - (_line1_width / 2)
					wrap_width[i] = _center_width
					positions_y[i] = box_y + margin + string_height_ext(text[i], line_spacing, wrap_width[i]) / 2 - v_padding
					break

				case directions.down:
					positions_x[i] = _center_x - (_line1_width / 2)
					wrap_width[i] = _center_width
					positions_y[i] = box_y + box_height - margin - string_height_ext(text[i], line_spacing, wrap_width[i]) / 2 + v_padding
					break

				case directions.left:
					positions_x[i] = _left_x
					positions_y[i] = _center_y
					wrap_width[i] = _side_width
					break

				case directions.right:
					positions_x[i] = _right_x
					positions_y[i] = _center_y
					wrap_width[i] = _side_width
					break
			}

			heart_x[i] = positions_x[i] - heart_offset
		}

		draw_set_font(_previous_font)
	}

	layout()

	static step = function() {
		var _target = -1

		if global.keys_pressed.up _target = index_of(directions.up)
		else if global.keys_pressed.down _target = index_of(directions.down)
		else if global.keys_pressed.left _target = index_of(directions.left)
		else if global.keys_pressed.right _target = index_of(directions.right)

		if _target != -1 && _target != selected {
			selected = _target
			ease_position(self, heart_x[selected], positions_y[selected], 0.15, easing.out_quad)
		}

		if selected != -1 && global.keys_pressed.confirm {confirmed = true}
	}

	static draw = function() {
        draw_set_halign(fa_left)
        draw_set_valign(fa_middle)
		draw_set_font(font)

		for (var i = 0; i < count; i++) {
			draw_text_ext(positions_x[i], positions_y[i], text[i], line_spacing, wrap_width[i])
		}
		draw_sprite_ext(spr_heart_small, 0, x, y, 2, 2, 0, c_white, 1)
	}
}