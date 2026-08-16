_typewriter.step();

// Advance page / close box on confirmation
if (global.keys_pressed.confirm && _typewriter.shown_chars == _typewriter.text_length) {
	if (current_page + 1 < pages_length) {
        current_page++
		_typewriter = new typewriter(
            format_basic, 
            is_undefined(pages[current_page].face) ? 32 : 25, 
            true, 
            pages[current_page].blip, 
            true, 
            pages[current_page].speaker, 
            pages[current_page].text,
            pages[current_page][$ "pitch_low"] ?? 1, 
            pages[current_page][$ "pitch_high"] ?? 1
        );
	} else {
		instance_destroy();
	}
}