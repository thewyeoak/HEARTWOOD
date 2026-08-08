global.joystick = 
{
    up : gamepad_axis_value(0, gp_axislv) <= -0.5,
    down : gamepad_axis_value(0, gp_axislv) >= 0.5,
    left : gamepad_axis_value(0, gp_axislh) <= -0.5,
    right : gamepad_axis_value(0, gp_axislh) >= 0.5,
}

global.keys_pressed =
{
    up : keyboard_check_pressed(vk_up) || global.joystick.up || gamepad_button_check_pressed(0, gp_padu),
    down : keyboard_check_pressed(vk_down) || global.joystick.down || gamepad_button_check_pressed(0, gp_padd),
    left : keyboard_check_pressed(vk_left) || global.joystick.left || gamepad_button_check_pressed(0, gp_padl),
    right : keyboard_check_pressed(vk_right) || global.joystick.right || gamepad_button_check_pressed(0, gp_padr),
    confirm : keyboard_check_pressed(ord("Z")) || keyboard_check_pressed(vk_enter) || gamepad_button_check_pressed(0, gp_face2),
    cancel : keyboard_check_pressed(ord("X")) || keyboard_check_pressed(vk_shift) || gamepad_button_check_pressed(0, gp_face1) || gamepad_button_check_pressed(0, gp_stickl),
    menu : keyboard_check_pressed(ord("C")) || keyboard_check_pressed(vk_control) || gamepad_button_check_pressed(0, gp_face4),
    escape: keyboard_check_pressed(vk_escape) || gamepad_button_check_pressed(0, gp_start),
	debug : keyboard_check_pressed(vk_f2)
}

global.keys_held =
{ 
    up : keyboard_check(vk_up) || global.joystick.up || gamepad_button_check(0, gp_padu),
    down : keyboard_check(vk_down) || global.joystick.down || gamepad_button_check(0, gp_padd),
    left : keyboard_check(vk_left) || global.joystick.left || gamepad_button_check(0, gp_padl),
    right : keyboard_check(vk_right) || global.joystick.right || gamepad_button_check(0, gp_padr),
    confirm : keyboard_check(ord("Z")) || keyboard_check(vk_enter) || gamepad_button_check(0, gp_face2),
    cancel : keyboard_check(ord("X")) || keyboard_check(vk_shift) || gamepad_button_check(0, gp_face1) || gamepad_button_check(0, gp_stickl),
    menu : keyboard_check(ord("C")) || keyboard_check(vk_control) || gamepad_button_check(0, gp_face4),
    escape: keyboard_check(vk_escape) || gamepad_button_check(0, gp_start),
	debug: keyboard_check(vk_f2)
}

global.keys_released =
{
    up : keyboard_check_released(vk_up) || !global.joystick.up || gamepad_button_check_released(0, gp_padu),
    down : keyboard_check_released(vk_down) || !global.joystick.down || gamepad_button_check_released(0, gp_padd),
    left : keyboard_check_released(vk_left) || !global.joystick.left || gamepad_button_check_released(0, gp_padl),
    right : keyboard_check_released(vk_right) || !global.joystick.right || gamepad_button_check_released(0, gp_padr),
    confirm : keyboard_check_released(ord("Z")) || keyboard_check_released(vk_enter) || gamepad_button_check_released(0, gp_face2),
    cancel : keyboard_check_released(ord("X")) || keyboard_check_released(vk_shift) || gamepad_button_check_released(0, gp_face1) || gamepad_button_check_released(0, gp_stickl),
    menu : keyboard_check_released(ord("C")) || keyboard_check_released(vk_control) || gamepad_button_check_released(0, gp_face4),
    escape: keyboard_check_released(vk_escape) || gamepad_button_check_released(0, gp_start),
	debug : keyboard_check_released(vk_f2)
}

global.time++