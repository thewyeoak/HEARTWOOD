enabled = false

width = 640; height = 641

open_height = 480; close_height = height

console_surface = -1

logs = []
command_history = []

command_count = 0
history_index = 0
backspace_timer = 0

scroll_offset = 0
char_limit = 64
input_string = ""; autocomplete_match = ""

commands = [
      {
        name: "help",
        description: "Describes and shows all commands' functions and usages.",
        cheat: false, 
        args: [],
        func: method(id, function() {
           for (var i = 0; i < array_length(commands); i++) {
               var _args_string = ""
               var _cmd = commands[i]
            
               for (var a = 0; a < array_length(_cmd.args); a++) { // required args formatted with <>
                   var _arg = ""
                   switch(_cmd.args[a]) {
                       case data_types.bool: _arg = "<boolean> "; break
                       case data_types.integer: _arg = "<integer> "; break
                       case data_types.real: _arg = "<real> "; break
                       case data_types.string: _arg = "<string> "; break
                   }
                   _args_string += _arg
               }
            
               var _opt_args = _cmd[$ "optional_args"] ?? []
            
               for (var a = 0; a < array_length(_opt_args); a++) { // optional args formatted with []
                   var _arg = ""
                   switch(_opt_args[a]) {
                       case data_types.bool: _arg = "[boolean] "; break
                       case data_types.integer: _arg = "[integer] "; break
                       case data_types.real: _arg = "[real] "; break
                       case data_types.string: _arg = "[string] "; break
                   }
                   _args_string += _arg
               }
            
               log_console("- " + _cmd.name + " " + _args_string + ": " + _cmd.description)
           }
        })
    },
    {
        name: "sv_cheats",
        description: "sv_cheats enables the usage of cheat commands, such as noclip, show hitboxes, and more. Enabling this marks the save file with a permanent tag that disables achievements.",
        cheat: false, // this is funny to me because its technically not one because we can run it without cheats
        args: [data_types.bool],
        func: method(id, function(_enabled) {
            var _string = _enabled ? "enabled" : "disabled"
            global.debug.cheats.enabled = _enabled
            
            if (_enabled) then {
                array_push(global.files.file_1.flags, "dirty_cheater") // TODO: do saves and replace with global.current_save.flags
            }
            log_console("sv_cheats have been " + _string + ".")
        })
    },
    {
        name: "set_border",
        description: "Sets the current border, check the borders enum for options.",
        cheat: false,
        args: [data_types.string],
        arg_options: [variable_struct_get_names(global.borders)],
        func: method(id, function(_input) {
            var _string = string_lower(_input)
            var _border_val = variable_struct_get(global.borders, _string)
            
            if (_border_val == undefined) {
                log_console("Error: Invalid border.", c_red)
                return
            }
            
            global.settings.border = _border_val
            update_window()
            log_console("Border has been set to " + _string + ".")
        })
    }, 
    {
        name: "room_goto",
        description: "Goes to the specified room at the index specified. an obj_marker instance must be in the specified room.",
        cheat: true,
        args: [data_types.string],
        optional_args: [data_types.integer],
        arg_options: [global.room_names],
        func: method(id, function(_room_name, _index = 0) {
            var _search = string_lower(_room_name)
            var _room_index = undefined
            
            for (var i = 0; i < array_length(global.rooms); i++) {
                if (string_lower(global.room_names[i]) == _search) {
                    _room_index = global.rooms[i]
                    break
                }
            }
            
            if (_room_index == undefined) {
                log_console("Error: '" + _room_name + "' is not a valid room.", c_red)
                return
            }
            
            global.spawn_index = _index
            room_goto(_room_index)
        })
    },
    {
        name: "window_scale",
        description: "Sets the window scale to the integer specified.",
        cheat: false,
        args: [data_types.integer],
        func: method(id, function(_num) {
            if (_num <= 0) || (_num > 5) {
                log_console("Error: Invalid window scale. Minimum is one and maximum is five.", c_red)
                return
            }
            
            global.settings.window_scale = _num
            update_window()
            log_console("window_scale has been set to " + string(_num) + ".")
        })
    },
    {
        name: "show_hitboxes",
        description: "Shows collision, triggers, interactables, and hazard zones as sprites in the world.",
        cheat: true,
        args: [data_types.bool],
        func: method(id, function(_enabled) {
            var _string = _enabled ? "enabled" : "disabled"
            global.debug.cheats.hitboxes = _enabled
            
            log_console("show_hitboxes has been " + _string + ".")
        })
    }
]

/// @description Strips out characters from input that aren't standard ASCII characters.
function normalize_input(_string) {
    var _clean = ""
    var _len = string_length(_string)
    for (var i = 1; i <= _len; i++) {
        var _char = string_char_at(_string, i)
        var _code = ord(_char);
        if (_code >= 32 && _code <= 126) {
            _clean += _char;
        }
    }
    return _clean
}

/// @description Logs specified string in GUI; does not run commands.
function log_console(_string, _color = c_white) {
    var _wrapped = wrap_formatted_text(string(_string), char_limit, false)
    var _lines = string_split(_wrapped, "\n")
    
    for (var i = 0; i < array_length(_lines); i++) {
        var _clean_line = string_replace_all(_lines[i], "\r", "")
        
        if (_clean_line != "") {
            array_push(logs, { text: _clean_line, color: _color })
        }
    }
    
    scroll_offset = 0
}

/// @description Runs any command specified by name in obj_console's commands array.
function run_command(_input) {
    if (_input == "") return
    array_push(command_history, _input)
    history_index = array_length(command_history)

    command_count++
    log_console("[" + string(command_count) + "] " + _input, c_gray)

    var _raw_args = string_split(_input, " ")
    var _cmd_name = _raw_args[0]
    array_delete(_raw_args, 0, 1)
    
    var _found = false
    for (var i = 0; i < array_length(commands); i++) {
        if (commands[i].name == _cmd_name) {
            _found = true
            
            var _cmd = commands[i]
            if (_cmd.cheat && !global.debug.cheats.enabled) {
                log_console("Error: sv_cheats must be true to use this command.", c_red)
                break
            }
            
            var _opt_args = _cmd[$ "optional_args"] ?? []
            
            var _req_count = array_length(_cmd.args)
            var _opt_count = array_length(_opt_args)
            var _given_count = array_length(_raw_args)
            
            if (_given_count < _req_count || _given_count > (_req_count + _opt_count)) {
                log_console("Usage: " + _cmd_name + " requires " + string(_req_count) + " to " + string(_req_count + _opt_count) + " arguments.", c_red)
                break
            }
            
            var _parsed_args = []
            var _valid_types = true
            
            for (var j = 0; j < _given_count; j++) {
                var _raw_val = string_trim(_raw_args[j])
                var _expected_type = (j < _req_count) ? _cmd.args[j] : _opt_args[j - _req_count]
                
                switch (_expected_type) {
                    case data_types.bool:
                        var _lower = string_lower(_raw_val)
                        if (_lower == "true" || _lower == "1") {array_push(_parsed_args, true)}
                        else if (_lower == "false" || _lower == "0") {array_push(_parsed_args, false);}
                        
                        else { 
                            log_console("Error: Argument " + string(j+1) + " must be a boolean (true/false).", c_red)
                            _valid_types = false
                        }
                    break
                        
                    case data_types.integer:
                    case data_types.real:
                        try {
                            var _num = real(_raw_val)
                            if (_expected_type == data_types.integer) _num = round(_num)
                            array_push(_parsed_args, _num)
                        } catch(e) {
                            log_console("Error: Argument " + string(j+1) + " must be a number.", c_red)
                            _valid_types = false
                        }
                    break
                        
                    case data_types.string:
                        array_push(_parsed_args, _raw_val)
                    break
                }
                
                if (!_valid_types) break
            }
            
            if (_valid_types) {
                switch (array_length(_parsed_args)) {
                    case 0: _cmd.func(); break
                    case 1: _cmd.func(_parsed_args[0]); break
                    case 2: _cmd.func(_parsed_args[0], _parsed_args[1]); break
                    case 3: _cmd.func(_parsed_args[0], _parsed_args[1], _parsed_args[2]); break
                    case 4: _cmd.func(_parsed_args[0], _parsed_args[1], _parsed_args[2], _parsed_args[3]); break
                } // just add more cases if SOMEHOW you have a command that needs more than 4 arguments
            }
            
            break
        }
    }
    
    if (!_found) {
        log_console("Unknown command: '" + _cmd_name + "'. Type 'help' for a list of commands.", c_red)
    }
}

/// @description Gives a list of valid autocomplete strings for a given argument slot of a command; can be specified through arg_options.
function get_arg_options(_cmd, _arg_index) {
    var _req_count = array_length(_cmd.args)
    var _opt_args = _cmd[$ "optional_args"] ?? []
    var _type = (_arg_index < _req_count) ? _cmd.args[_arg_index] : _opt_args[_arg_index - _req_count]
    
    var _custom = _cmd[$ "arg_options"]
    if (_custom != undefined && _arg_index < array_length(_custom)) {
        var _source = _custom[_arg_index]
        if (_source != undefined) {
            return is_method(_source) ? _source() : _source
        }
    }
    
    if (_type == data_types.bool) {
        return ["true", "false"]
    }
    
    return []
}