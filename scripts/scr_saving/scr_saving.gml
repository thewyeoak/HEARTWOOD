function save_player()
{
    
}

function load_player()
{
    
}

function load_settings()
{
    if (file_exists("settings.json")) {
    	var buffer = buffer_load("settings.json");
    	var json = buffer_read(buffer, buffer_string);
    	buffer_delete(buffer);
    	var data = json_parse(json);
    	
    	var names = struct_get_names(global.settings);
    	var names_length = array_length(names);
    	
    	for (var i = 0; i < names_length; i++) {
    		if (variable_struct_exists(data, names[i])) {
    			variable_struct_set(global.settings, names[i], variable_struct_get(data, names[i]));
    		}
    	}
    } else {
        // Create a default save file if one doesn't exist
    	var file = file_text_open_write("settings.json");
    	file_text_write_string(file, json_stringify(global.settings));
    	file_text_close(file);
    }
}

function save_settings() {
    var file = file_text_open_write("settings.json");
	file_text_write_string(file, json_stringify(global.settings));
	file_text_close(file);
}

function load_flags()
{
    if (file_exists("saves.json")) {
	var buffer = buffer_load("saves.json");
	var json = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	var data = json_parse(json);
	
	var names = struct_get_names(global.files);
	var names_length = array_length(names);
	
	for (var i = 0; i < names_length; i++) {
		if (variable_struct_exists(data, names[i])) {
			variable_struct_set(global.files, names[i], variable_struct_get(data, names[i]));
		}
	}
} else {
	// Create a default save file if one doesn't exist
	var file = file_text_open_write("saves.json");
    file_text_write_string(file, json_stringify(global.files));
	file_text_close(file);
    }
}

function save_flags() {
    var file = file_text_open_write("saves.json");
    file_text_write_string(file, json_stringify(global.files));
    file_text_close(file);
}

function save_all() {
    save_flags()
    save_settings()
}

function load_all() {
    load_flags()
    load_settings()
}