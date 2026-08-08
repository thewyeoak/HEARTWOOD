if !global.debug.display{
    exit;
}

// --- left side ---
draw_set_halign(fa_left)
draw_text_outline(h_margin, v_margin + q_margin, fnt_small_big, "FPS " + string(round(fps_real)), c_white, outline_color)

var y_pos = v_margin + l_margin + q_margin
var inputs = [
    {state: global.keys_held.up, offset: 0, text: "UP"},
    {state: global.keys_held.down, offset: 30, text: "DOWN"},
    {state: global.keys_held.left, offset: 80, text: "LEFT"},
    {state: global.keys_held.right, offset: 130, text: "RIGHT"}
]

for (var i = 0; i < array_length(inputs); i++) {
    var item = inputs[i]
    var color = item.state ? inactive_color : active_color 
    
    draw_text_outline(h_margin + item.offset, y_pos, fnt_small_big, item.text, color, outline_color)
}

y_pos = v_margin + l_margin*2 + q_margin
inputs = [
    {state: global.keys_held.confirm, offset: 0, text: "Z"},
    {state: global.keys_held.cancel, offset: 20, text: "X"},
    {state: global.keys_held.menu, offset: 40, text: "C"},
]

for (var i = 0; i < array_length(inputs); i++) {
    var item = inputs[i]
    var color = item.state ? inactive_color : active_color
    
    draw_text_outline(h_margin + item.offset, y_pos, fnt_small_big, item.text, color, outline_color)
}

// --- right side ---
draw_set_halign(fa_right)

if (instance_exists(obj_player)) {
    var h_pos = display_get_gui_width() - h_margin
    
    var direction_text = ["UP", "DOWN", "LEFT", "RIGHT"]
    var facing = direction_text[obj_player.facing]
    var moving = obj_player.moving ? "YES" : "NO"
    
    var stats = [
        "X: " + string(obj_player.x),
        "Y: " + string(obj_player.y),
        "FACE: " + facing,
        "MOVING: " + moving
    ]
    
    for (var i = 0; i < array_length(stats); i++) {
        draw_text_outline(h_pos, v_margin + (l_margin * i), fnt_small_big, stats[i])
    }
}

draw_set_halign(fa_left)