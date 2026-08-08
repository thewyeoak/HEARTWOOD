_typewriter.step();

// Advance page / close box on confirmation
if (global.keys_pressed.confirm && _typewriter.shown_chars == _typewriter.text_length) {
	if (++current_page < pages_length) {
		_typewriter = new typewriter(format_battle, 32, true, snd_blip_battle, true, noone, pages[current_page]);
	} else {
		instance_destroy();
	}
}