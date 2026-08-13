function can_player_move() {
    var _console_closed = !instance_exists(obj_console) || !obj_console.enabled
    var _dialogue_closed = !instance_exists(obj_dialogue_box)

    return _dialogue_closed && _console_closed
}