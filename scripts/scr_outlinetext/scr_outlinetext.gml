function draw_text_outline(x, y, font, text, text_color = c_white, outline_color = c_black, outline_width = 2) {
    draw_set_font(font);
    draw_set_colour(outline_color)
    
    var width = outline_width
    for (var _x = -width; _x <= width; _x++) {
        for (var _y = -width; _y <= width; _y++) {
            if (_x != 0 || _y != 0) {
                draw_text(x + _x, y + _y, text);
            }
        }
    }
    
    draw_set_colour(text_color)
    draw_text(x, y, text)
    draw_set_colour(c_white)
}