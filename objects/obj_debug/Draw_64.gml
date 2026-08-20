if !global.debug.display{
    exit
}

// --- left side ---
draw_set_halign(fa_left)
draw_text_outline(h_margin, v_margin + q_margin, fnt_small_big, "FPS " + string(round(fps_real)), c_white, outline_color)

var _y_pos = v_margin + l_margin + q_margin
var _inputs = [
    {state: global.keys_held.up, offset: 0, text: "UP"},
    {state: global.keys_held.down, offset: 30, text: "DOWN"},
    {state: global.keys_held.left, offset: 80, text: "LEFT"},
    {state: global.keys_held.right, offset: 130, text: "RIGHT"}
]

for (var i = 0; i < array_length(_inputs); i++) {
    var _item = _inputs[i]
    var _color = _item.state ? inactive_color : active_color 
    
    draw_text_outline(h_margin + _item.offset, _y_pos, fnt_small_big, _item.text, _color, outline_color)
}

_y_pos = v_margin + l_margin*2 + q_margin
_inputs = [
    {state: global.keys_held.confirm, offset: 0, text: "Z"},
    {state: global.keys_held.cancel, offset: 20, text: "X"},
    {state: global.keys_held.menu, offset: 40, text: "C"},
]

for (var i = 0; i < array_length(_inputs); i++) {
    var _item = _inputs[i]
    var _color = _item.state ? inactive_color : active_color
    
    draw_text_outline(h_margin + _item.offset, _y_pos, fnt_small_big, _item.text, _color, outline_color)
}

// --- right side ---
draw_set_halign(fa_right)

if (instance_exists(obj_player)) {
    var _h_pos = game_width - h_margin
    
    var _direction_text = ["UP", "DOWN", "LEFT", "RIGHT"]
    var _facing = _direction_text[obj_player.facing]
    var _moving = obj_player.moving ? "YES" : "NO"
    
    var _stats = [
        "X: " + string(obj_player.x),
        "Y: " + string(obj_player.y),
        "FACE: " + _facing,
        "MOVING: " + _moving
    ]
    
    for (var i = 0; i < array_length(_stats); i++) {
        draw_text_outline(_h_pos, v_margin + (l_margin * i), fnt_small_big, _stats[i])
    }
}

draw_set_halign(fa_left)