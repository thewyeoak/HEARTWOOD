global.current_cutscene = undefined
global.cutscene_queue = []

function cutscene_create() {
    return new cutscene()
}

// starts a cutscene, or queues it behind whatever is already playing
function cutscene_start(cs) {
    if (global.current_cutscene != undefined) {
        array_push(global.cutscene_queue, cs)
        return cs
    }

    cs.start()
    global.current_cutscene = cs

    return cs
}

function cutscene_update_current() {
    if (global.current_cutscene == undefined) {return}
    if (!global.current_cutscene.step()) {return}

    global.current_cutscene = undefined

    if (array_length(global.cutscene_queue) > 0) {
        var _next = global.cutscene_queue[0]
        array_delete(global.cutscene_queue, 0, 1)
        cutscene_start(_next)
    }
}

function cutscene() constructor {
    started = false
    done = false
    cutscene_step = 0
    cutscene_events = []
    active_events = []

    static add_events = function(ev) {
        array_push(cutscene_events, ev)
        return self
    }

    static _then = function(_ev) {
        return add_events([_ev])
    }

    static _and = function() {
        var _group = array_create(argument_count)

        for (var i = 0; i < argument_count; i++) {
            _group[i] = argument[i]
        }

        return add_events(_group)
    }

    static begin_group = function() {
        var _group = cutscene_events[cutscene_step]
        active_events = []

        for (var i = 0; i < array_length(_group); i++) {
            array_push(active_events, _group[i])
            _group[i].initialize()
        }
    }

    static start = function() {
        if (started || array_length(cutscene_events) == 0) {return self}

        started = true
        done = false
        cutscene_step = 0
        begin_group()

        return self
    }

    // returns true once the whole cutscene has finished
    static step = function() {
        if (!started) {return done}
        for (var i = array_length(active_events) - 1; i >= 0; i--) {
            if (active_events[i].step()) {
                array_delete(active_events, i, 1)
            }
        }

        if (array_length(active_events) > 0) {return false}

        cutscene_step++
        
        if (cutscene_step >= array_length(cutscene_events)) {
            started = false
            done = true
            cutscene_step = 0
            show_debug_message("Cutscene ended.")

            return true
        }

        begin_group()

        return false
    }
}

function cutscene_event() constructor {
    static initialize = function() {}
    static step = function() {return true}
}

function ev_instance_backed() : cutscene_event() constructor {
    instance = noone

    static step = function() {
        return !instance_exists(instance)
    }
}

function ev_typewriter(_x, _y, _text, _opts = {}) : ev_instance_backed() constructor {
    x = _x
    y = _y
    text = _text
    opts = _opts

    static initialize = function() {
        instance = create_dialogue_at(x, y, [dialogue_page(text, opts)])
    }
}

function ev_dialogue(_pages, _side = undefined) : ev_instance_backed() constructor {
    side = _side
	pages = _pages

	static initialize = function() {
		instance = create_dialogue(side, pages)
	}
}

function ev_dialogue_basic(_pages, _speaker = noone) : ev_instance_backed() constructor {
	pages = _pages
	speaker = _speaker

	static initialize = function() {
		instance = create_dialogue_basic(pages, speaker)
	}
}

function ev_dialogue_bubble(_tail_x, _tail_y, _tail_side, _width, _height, _pages) : ev_instance_backed() constructor {
    tail_x = _tail_x
    tail_y = _tail_y
    tail_side = _tail_side
    width = _width
    height = _height
    pages = _pages

    static initialize = function() {
        instance = create_dialogue_bubble(tail_x, tail_y, tail_side, width, height, pages)
    }
}

function ev_choice(_choices, _callback, _side = undefined) : ev_instance_backed() constructor {
    side = _side
    choices = _choices
    callback = _callback

    static initialize = function() {
        instance = create_dialogue_choice_only(side, choices, callback)
    }
}

function ev_move_camera(_tox, _toy, _duration, _ease) : cutscene_event() constructor {
    tox = _tox
    toy = _toy
    duration = _duration
    ease = _ease

    static initialize = function() {
        ease_position(obj_camera.id, tox, toy, duration, ease)
	}

	static step = function() {
		return !ease_is_active(obj_camera.id, "x")
	}
}

function ev_delay(_seconds) : cutscene_event() constructor {
	seconds = _seconds

	static step = function() {
		seconds -= delta_time / 1000000
        return seconds <= 0
	}
}

function ev_execute_script(_script) : cutscene_event() constructor {
    script = _script

    static initialize = function() {script()}
}

function ev_execute_script_while(_script, _check) : cutscene_event() constructor {
    script = _script
    check = _check

	static step = function() {
        if (check()) {return true}

        script()

        return false
	}
}