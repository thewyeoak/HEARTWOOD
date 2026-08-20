dir_x = can_move ? (global.keys_held.right - global.keys_held.left) : 0
dir_y = can_move ? (global.keys_held.down - global.keys_held.up) : 0

// counted down here rather than on an alarm so it can't outlive the instance
if (immunity) {
    immunity_timer -= delta_time / 1000000

    if (immunity_timer <= 0) {
        immunity = false
        image_index = 0
        image_speed = 0
    }
}

var _hit_bullet = instance_place(x, y, obj_bullet)

if (immunity || _hit_bullet == noone) {exit}
if (!variable_instance_exists(_hit_bullet, "damage")) {exit}
if (_hit_bullet.damage == 0) {exit}

immunity = true

var _survives_lethal = (mode == soul_mode.overworld && global.stats.hp >= 2)

global.stats.hp -= _hit_bullet.damage
global.stats.hp = (_survives_lethal && global.stats.hp <= 0) ? 1 : max(0, global.stats.hp)

if (global.stats.hp == 0) {
    die()
    exit
}

if (instance_exists(obj_camera)) {
    obj_camera.apply_shake(3, 0.5)
}

image_index = 0
image_speed = 1
play_sfx(snd_hurt, 1)

immunity_timer = immunity_time