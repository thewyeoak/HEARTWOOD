global.current_cutscene = undefined

function cutscene_create() {
    return new cutscene()
}

function cutscene_start(cs) {
    if (global.current_cutscene != undefined)
    {
        show_error("Can't start a cutscene while one is already playing!", false)
        return
    }
    
    cs.start()
    global.current_cutscene = cs
}

function cutscene_update_current() {
    if (global.current_cutscene != undefined)
    {
        if (global.current_cutscene.step())
        {
            global.current_cutscene = undefined
        }
    }
}

function cutscene() constructor {
    started = false
    done = false
    cutscene_step = 0
    cutscene_events = []
    
    static add_events = function(ev) {
        array_push(cutscene_events, ev)
        return self
    }
    
    static start = function() {
        if (started) {return self}
        
        started = true
        done = false
        
        for (var i = 0; i < array_length(cutscene_events[0]); i++) {
            cutscene_events[0][i].initialize()
        }
        
        return self
    }
    
    static step = function()
    {
        if (started == false) {return}
        
        var ev_done = 0
        
        for (var i = 0; i < array_length(cutscene_events[cutscene_step]); i++) {
            if (cutscene_events[cutscene_step][i].step() == false) {
                ev_done++
            }
        }
        
        if (ev_done >= array_length(cutscene_events[cutscene_step])) {
            cutscene_step++
            
            if (cutscene_step >= array_length(cutscene_events)) {
                started = false
                done = true
                cutscene_step = 0
                show_debug_message("Cutscene ended.")
                return true
            }
            else {
                for (var z = 0; z < array_length(cutscene_events[cutscene_step]); z++) {
                    cutscene_events[cutscene_step][z].initialize()
                }
                
                return false
            }
        }
    }
}

function ev_typewriter(_x, _y, _font, _char_spacing, _line_spacing, _line_length, _add_asterisks, _blip, _can_skip, _speaker, _text, _pitch_low = 1, _pitch_high = 1) constructor {
    pos_x = _x;
    pos_y = _y;
    font = _font;
    char_spacing = _char_spacing;
    line_spacing = _line_spacing;
    line_length = _line_length;
    add_asterisks = _add_asterisks;
    blip = _blip;
    can_skip = _can_skip;
    speaker = _speaker;
    text = _text;
    pitch_low = _pitch_low;
    pitch_high = _pitch_high;

    instance = noone

    static initialize = function() {
        instance = instance_create_layer(pos_x, pos_y, "Systems", obj_dialogue, {
            font: font,
            char_spacing: char_spacing,
            line_spacing: line_spacing,
            line_length: line_length,
            add_asterisks: add_asterisks,
            blip: blip,
            can_skip: can_skip,
            speaker: speaker,
            text: text,
            pitch_low: pitch_low,
            pitch_high: pitch_high
        });
    }

    static step = function() {
        if (!instance_exists(instance)) return false
        if (instance._typewriter.shown_chars >= instance._typewriter.text_length && global.keys_pressed.confirm) {
            instance_destroy(instance)
            return false
        }
        return true
    }
}

function ev_dialogue(_side, _pages) constructor {
    side = _side
	pages = _pages
	
	static initialize = function() {
		dialogue_box = create_dialogue(side, pages)
	}
	
	static step = function() {
		return instance_exists(dialogue_box)
	}
}

function ev_dialogue_basic(_pages, _speaker = noone) constructor {
	pages = _pages
	speaker = _speaker
	
	static initialize = function() {
		dialogue_box = create_dialogue_basic(pages, speaker)
	}
	
	static step = function() {
		return instance_exists(dialogue_box)
	}
}

function ev_dialogue_bubble(_tail_x, _tail_y, _tail_side, _width, _height, _pages) constructor {
    tail_x = _tail_x
    tail_y = _tail_y
    tail_side = _tail_side
    width = _width
    height = _height
    pages = _pages

    static initialize = function() {
        dialogue_box = create_dialogue_bubble(tail_x, tail_y, tail_side, width, height, pages)
    }

    static step = function() {
        return instance_exists(dialogue_box)
    }
}

function dialogue_page(_text, _face_sprite = undefined, _talk_sprite = noone, _face_image = 0, _blip = snd_blip_generic, _speaker = noone, _pitch_low = 1, _pitch_high = 1) {
    var _face_struct = undefined
    
    if (!is_undefined(_face_sprite)) {
        _face_struct = {
            sprite: _face_sprite,
            talk_sprite: _talk_sprite,
            image: _face_image
        };
    }

    return {
        text: _text,
        face: _face_struct,
        blip: _blip,
        speaker: _speaker,
        pitch_low: _pitch_low,
        pitch_high: _pitch_high
    }
}

function ev_move_camera(_tox, _toy, _duration, _ease) constructor  {
    tox = _tox
    toy = _toy
    duration = _duration
    ease = _ease
    
    static initialize = function() {
        ease_position(obj_camera.id, tox, toy, duration, ease)
	}
	
	static step = function() {
		return ease_find_index(obj_camera.id, "x")
	}
}

function ev_delay(_seconds) constructor {
	seconds = _seconds
    
    static initialize = function() {}
	static step = function() 
    {
		seconds -= 1 * (delta_time / 1000000)
        return seconds > 0
	}
}

function ev_execute_script(_script) constructor {
    script = _script
    
    static initialize = function(){script()}
	
	static step = function() {
        return false
	}
}

function ev_execute_script_while(_script, _check) constructor {
    script = _script
    check = _check
    
    static initialize = function() {}
	static step = function() {
        if (check()) {
            return false
        }
        else {
        	script()
            return true
        }
	}
}