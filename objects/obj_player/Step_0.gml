var _can_move = can_player_move()

var _dir_x = _can_move ? (global.keys_held.right - global.keys_held.left) : 0
var _dir_y = _can_move ? (global.keys_held.down - global.keys_held.up) : 0

var _holding_run = global.keys_held.cancel && can_run
var _movement_spd = _holding_run ? run_speed : walk_speed

if (global.debug.cheats.noclip) {
    x += _dir_x * run_speed
    y += _dir_y * run_speed
} else {
    move_collide_x(_dir_x, _movement_spd, _dir_y == 0)
    move_collide_y(_dir_y, _movement_spd, _dir_x == 0)
}

if (_dir_x == 0) {
    if (_dir_y == -1) facing = directions.up
    else if (_dir_y == 1) facing = directions.down
} else if (_dir_y == 0) {
    if (_dir_x == -1) facing = directions.left
    else if (_dir_x == 1) facing = directions.right
} else {
    switch (facing) {
        case directions.left:
            if (_dir_x == 1) facing = directions.right
            break

        case directions.right:
            if (_dir_x == -1) facing = directions.left
            break

        case directions.up:
            if (_dir_y == 1) facing = directions.down
            break

        case directions.down:
            if (_dir_y == -1) facing = directions.up
            break
    }
}

sprite_index = sprites[facing]

var _old_moving = moving
moving = (x != xprevious) || (y != yprevious)

var _running = moving && _holding_run

if (moving != _old_moving) {
    if (moving) {
        image_index = 1
    } else {
        image_index = 0
        image_speed = 0
        time = 0
    }
}

if (moving) {
    image_speed = _running ? 5 / 3 : 1
}

if (swallow_interact) {
    swallow_interact = false
} else if (_can_move && global.keys_pressed.confirm) {
    try_interact()
}

if (!_can_move) {
    swallow_interact = true
}

var _target_footstep = _running ? base_footstep / 2 : base_footstep

if (footstep && moving) {
    if (time == 0) {
        play_sfx(snd_step1, 1)
    }

    if (time == _target_footstep) {
        play_sfx(snd_step2, 1)
    }

    time++

    if (time >= _target_footstep * 2) {
        time = 0
    }
}