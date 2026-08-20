event_inherited()

target = {
    x: 0,
    y: 0
}

self_target = {
    x: 100,
    y: 100
}

target_object = undefined
target_angle = 0

recoil_x = 0
recoil_y = 0

initialized = false
fire_delay = 30

spawn_padding = 50

approach_lerp = 0.2
turn_lerp = 0.2
fire_frame = 4

// recoil eases in so the blaster drifts back before being flung off screen
recoil_ease = easing.in_cubic
recoil_duration = 1.1
recoil_distance = 1000
despawn_distance = 800

image_speed = 0
image_index = 0

state = blaster_state.idle

move_offscreen = function() {
    var _dist_left = self_target.x
    var _dist_right = room_width - self_target.x
    var _dist_top = self_target.y
    var _dist_bottom = room_height - self_target.y

    var _nearest_edge = min(_dist_left, _dist_right, _dist_top, _dist_bottom)

    x = self_target.x
    y = self_target.y

    if (_nearest_edge == _dist_left) {
        x = -spawn_padding
    } else if (_nearest_edge == _dist_right) {
        x = room_width + spawn_padding
    } else if (_nearest_edge == _dist_top) {
        y = -spawn_padding
    } else {
        y = room_height + spawn_padding
    }
}

initialize = function() {
    if (!is_undefined(target_object) && instance_exists(target_object)) {
        target.x = target_object.x
        target.y = target_object.y
    }

    target_angle = point_direction(self_target.x, self_target.y, target.x, target.y)
    image_angle = target_angle + 180

    move_offscreen()

    initialized = true
    play_sfx(snd_blastercharge, 0.25)
    alarm[0] = fire_delay
}

fire = function() {
    state = blaster_state.recoil

    var _beam = instance_create_depth(x, y, depth + 1, obj_gblasterbeam)

    _beam.image_angle = image_angle
    _beam.creator = id
    _beam.max_thickness = image_yscale * 3
    _beam.damage = damage

    play_sfx(snd_blasterfire, 0.5)

    if (instance_exists(obj_camera)) {
        obj_camera.apply_shake(1, 0.25)
    }

    recoil_x = x - lengthdir_x(recoil_distance, image_angle)
    recoil_y = y - lengthdir_y(recoil_distance, image_angle)

    ease_position(id, recoil_x, recoil_y, recoil_duration, recoil_ease)
}