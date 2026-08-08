is_dark = false

horizontal_margin = 28;
face_text_offset = 116;

box_height = 152;

if is_dark {
    box_margin_w = 32-8;
    box_width = 593;
    box_height = 167;
    vertical_margin = 28;
    horizontal_margin = 40;
    sprite_index = spr_darkbox
    
    // Get position of the top of the box
    rect_y = (side == directions.up) ? 10 : 311;
} else {
    box_margin_w = 32
    box_width = 578;
    box_height = 152;
    vertical_margin = 21;
    horizontal_margin = 28;
    
    rect_y = (side == directions.up) ? 10 : 320;
}


// The "div 4 * 2"s ensure we keep to the double pixel grid used in the overworld
face_offset_w = 6 + (horizontal_margin + face_text_offset - 6) div 4 * 2;
face_offset_h = box_height div 4 * 2 - 1;  // -1 to stay on the double pixel grid

// Automatically find box side based on player position (if it's not already defined)
if (is_undefined(side)) {
	side = (obj_player.y - 26 - camera_get_view_y(view_camera[0]) > 120 ? directions.up : directions.down);
}

// Get positions to create typewriters at
text_x = box_margin_w + horizontal_margin;
text_x_with_face = box_margin_w + horizontal_margin + face_text_offset;
text_y = rect_y + vertical_margin;

pages_length = array_length(pages);
current_page = 0;

_typewriter = new typewriter(format_basic, is_undefined(pages[0].face) ? 32 : 25, true, pages[0].blip, true, pages[0].speaker, pages[0].text);

// This is incremented every frame, so to prevent the first talk sprite only appearing for three frames we have to set this to -1.
face_talk_counter = -1;