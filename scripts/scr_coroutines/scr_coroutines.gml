global.routines = []
global.routine_next_id = 0

// @param {function} check This function will run and check if it returns true
// @param {function} callback This function will run when "check" returns true
function call_when_true(check, callback) {
	var _id = global.routine_next_id++
	array_push(global.routines, { id: _id, type: 0, check_func: check, call_func: callback })
	return _id
}

function update_routines() {
	for (var i = 0; i < array_length(global.routines); i++) {
		var _routine = global.routines[i]
		
		switch (_routine.type) {
			case 0:
				if (_routine.check_func()) {
					// remove before calling so the callback can start a new routine
					array_delete(global.routines, i, 1)
					i--
					_routine.call_func()
				}
            break
		}
	}
}

function stop_coroutine(_id) {
	for (var i = 0; i < array_length(global.routines); i++) {
		if (global.routines[i].id == _id) {
			array_delete(global.routines, i, 1)
			return true
		}
	}

	return false
}