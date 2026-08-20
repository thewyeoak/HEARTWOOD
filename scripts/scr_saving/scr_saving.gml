function save_player()
{
    // todo
}

function load_player()
{
    // todo two
}

function json_load_into(_file, _target) {
    if (!file_exists(_file)) {
        json_save(_file, _target)
        return false
    }

    var _buffer = buffer_load(_file)
    var _data = json_parse(buffer_read(_buffer, buffer_string))
    buffer_delete(_buffer)

    var _names = struct_get_names(_target)

    for (var i = 0; i < array_length(_names); i++) {
        if (variable_struct_exists(_data, _names[i])) {
            _target[$ _names[i]] = _data[$ _names[i]]
        }
    }

    return true
}

function json_save(_file, _data) {
    var _handle = file_text_open_write(_file)
    file_text_write_string(_handle, json_stringify(_data))
    file_text_close(_handle)
}

function load_settings() {
    json_load_into("settings.json", global.settings)
}

function save_settings() {
    json_save("settings.json", global.settings)
}

function load_flags() {
    json_load_into("saves.json", global.files)
}

function save_flags() {
    json_save("saves.json", global.files)
}

function save_all() {
    save_flags()
    save_settings()
}

function load_all() {
    load_flags()
    load_settings()
}