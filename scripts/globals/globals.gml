randomize();

global.time = 0
global.spawn_index = 0;

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

global.debug =
{
    cheats:
    {
        enabled: true,
        noclip: false,
        hitboxes: true
    },
    
    console: false,
    display: true,
    build: false
}