function move_collide_x(_dir, _speed, _slope_assist = false) { // moving this here for Universal Collision (i.e for npcs n such)
	if (_dir == 0) {return}

	var _start_x = x
	var _step = sign(_dir)

	x += _dir * _speed

	if (!place_meeting(x, y, obj_collision)) {return}

	x = _start_x

	while (!place_meeting(x + _step, y, obj_collision)) {
		x += _step
	}

	if (!_slope_assist) {return}

	repeat (_speed - abs(x - _start_x)) {
		if (!place_meeting(x + _step, y, obj_collision)) {
			x += _step
		} else if (!place_meeting(x + _step, y - 1, obj_collision)) {
			x += _step
			y -= 1
		} else if (!place_meeting(x + _step, y + 1, obj_collision)) {
			x += _step
			y += 1
		}
	}
}

function move_collide_y(_dir, _speed, _slope_assist = false) {
	if (_dir == 0) {return}

	var _start_y = y
	var _step = sign(_dir)

	y += _dir * _speed

	if (!place_meeting(x, y, obj_collision)) {return}

	y = _start_y

	while (!place_meeting(x, y + _step, obj_collision)) {
		y += _step
	}

	if (!_slope_assist) {return}

	repeat (_speed - abs(y - _start_y)) {
		if (!place_meeting(x, y + _step, obj_collision)) {
			y += _step
		} else if (!place_meeting(x - 1, y + _step, obj_collision)) {
			x -= 1
			y += _step
		} else if (!place_meeting(x + 1, y + _step, obj_collision)) {
			x += 1
			y += _step
		}
	}
}