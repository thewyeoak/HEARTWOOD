global.current_cutscene = undefined;

function cutscene_create()
{
    return new cutscene();
}

function cutscene_start(cs)
{
    if (global.current_cutscene != undefined)
    {
        show_debug_message("Cant start another cutscene while one is playing")
        return;
    }
    
    cs.start();
    global.current_cutscene = cs;
}

function cutscene_update_current()
{
    if (global.current_cutscene != undefined)
    {
        if (global.current_cutscene.step())
        {
            global.current_cutscene = undefined;
            obj_player.can_move = true;
        }
    }
}

function cutscene() constructor 
{
    started = false;
    done = false;
    cutscene_step = 0;
    cutscene_events = [];
    
    static add_events = function(ev)
    {
        array_push(cutscene_events, ev);
        return self;
    }
    
    static start = function()
    {
        if (started) {return self;}
        
        started = true;
        done = false;
        
        for (var i = 0; i < array_length(cutscene_events[0]); i++)
        {
            cutscene_events[0][i].initialize();
        }
        
        return self;
    }
    
    static step = function()
    {
        if (started == false) {return;}
        
        var ev_done = 0;
        
        for (var i = 0; i < array_length(cutscene_events[cutscene_step]); i++)
        {
            if (cutscene_events[cutscene_step][i].step() == false)
            {
                ev_done++;
            }
        }
        
        if (ev_done >= array_length(cutscene_events[cutscene_step]))
        {
            cutscene_step++;
            
            if (cutscene_step >= array_length(cutscene_events))
            {
                started = false;
                done = true;
                cutscene_step = 0;
                show_debug_message("Cutscene ended");
                return true;
            }
            else 
            {
                for (var z = 0; z < array_length(cutscene_events[cutscene_step]); z++)
                {
                    cutscene_events[cutscene_step][z].initialize();
                }
                
                return false;
            }
        }
    }
}

function ev_dialogue(_side, _pages) constructor 
{
    side = _side;
	pages = _pages;
	
	static initialize = function() {
		dialogue_box = create_dialogue(side, pages);
	}
	
	static step = function() {
		return instance_exists(dialogue_box);
	}
}

function ev_dialogue_basic(_pages, _speaker = noone) constructor 
{
	pages = _pages;
	speaker = _speaker;
	
	static initialize = function() {
		dialogue_box = create_dialogue_basic(pages, speaker);
	}
	
	static step = function() {
		return instance_exists(dialogue_box);
	}
}

function ev_move_camera(_tox, _toy, _duration, _ease) constructor 
{
    tox = _tox;
    toy = _toy;
    duration = _duration;
    ease = _ease;
    
    static initialize = function() {
        ease_position(obj_camera.id, tox, toy, duration, ease)
	}
	
	static step = function() {
		return ease_find_index(obj_camera.id, "x")
	}
}

function ev_delay(_seconds) constructor 
{
	// .step() is run on the same frame as the event is started, so if we didn't add 1 to the frame count
	// we would always wait for one less frame than intended.
	seconds = _seconds;
    
    static initialize = function() 
    {
		
	}
	
	static step = function() 
    {
		seconds -= 1 * (delta_time / 1000000);
        show_debug_message(seconds);
        return seconds > 0
	}
}

function ev_execute_script(_script) constructor 
{
    script = _script;
    
    static initialize = function() 
    {
		script();
	}
	
	static step = function() 
    {
        return false;
	}
}

function ev_execute_script_while(_script, _check) constructor 
{
    script = _script;
    check = _check;
    
    static initialize = function() 
    {

	}
	
	static step = function() 
    {
        if (check())
        {
            return false;
        }
        else 
        {
        	script();
            return true;
        }
	}
}