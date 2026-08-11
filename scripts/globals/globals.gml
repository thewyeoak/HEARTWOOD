randomize()

global.time = 0
global.spawn_index = 0

global.borders = {
    off: -1,
    blank: 0,
    sepia: 1
}

global.debug =
{
    cheats:
    {
        enabled: false,
        noclip: false,
        hitboxes: false
    },
    
    console: true,
    display: true,
    build: false
}

global.keys_pressed = 
{
    up: false,
    down : false,
    left : false,
    right : false,
    confirm : false,
    cancel : false,
    menu : false,
    escape : false,
	debug : false
}

global.keys_held = 
{
    up: false,
    down : false,
    left : false,
    right : false,
    confirm : false,
    cancel : false,
    menu : false,
    escape : false,
	debug : false
}

global.keys_released = 
{
    up: false,
    down : false,
    left : false,
    right : false,
    confirm : false,
    cancel : false,
    menu : false,
    escape : false,
	debug : false
} 

global.joystick = 
{
	up: false,
	down: false,
	left: false,
	right: false
}