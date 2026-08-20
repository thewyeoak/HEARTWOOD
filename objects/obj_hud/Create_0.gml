// VERY inspired by doghole dungeon, but to be fair they were borrowing from undertale anyways so... fair game?
enabled = false
prev_enabled = enabled

total_height = 40
width = game_width
height = game_height

display_surface = -1

anim_offset = enabled ? 0 : total_height

h_offsets = {
    name: 30,
    lv: 132,
    hp_label: 244,
    hp: 275
}

v_offset = 9

// how the bar slides in and out when the hud is toggled
slide_time = 0.4
slide_ease = easing.out_cubic

// hp bar sizing and colours
bar_scale = 1.2
bar_gap = 15
bar_height = 30
bar_back_color = c_red
bar_fill_color = c_yellow