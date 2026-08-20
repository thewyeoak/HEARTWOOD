temp_font_load = fnt_main

// --- resolution ---
#macro game_width 640
#macro game_height 480

// --- border ---
// the border art frames the game area so the window grows by the inset on every side
#macro border_inset_x 160
#macro border_inset_y 30
#macro bordered_width (game_width + border_inset_x * 2)
#macro bordered_height (game_height + border_inset_y * 2)

// --- camera ---
#macro cam view_camera[0]
#macro cam_x camera_get_view_x(cam)
#macro cam_y camera_get_view_y(cam)
#macro cam_w camera_get_view_width(cam)
#macro cam_h camera_get_view_height(cam)

// --- fonts ---
// each of these is a fresh struct so it's safe to merge extra fields into one
#macro format_basic {font: fnt_main, char_spacing: 16, line_spacing: 36}
#macro format_gameover {font: fnt_main, char_spacing: 20, line_spacing: 36}
#macro format_text {font: fnt_maintext, char_spacing: 8, line_spacing: 17}
#macro format_battle {font: fnt_main, char_spacing: 16, line_spacing: 32}
#macro format_bubble {font: fnt_dialogue_battle, char_spacing: 9, line_spacing: 20}