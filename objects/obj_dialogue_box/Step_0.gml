_typewriter.step()

var _text_done = _typewriter.shown_chars == _typewriter.text_length
var _choices = pages[current_page][$ "choices"]

if (_text_done && !is_undefined(_choices)) {
	if (_choice_selector == noone) {
		_choice_selector = new choice_selector(_choices, pages[current_page].choice_inputs, fnt_main, 32, box_margin_w, rect_y, box_width, box_height, horizontal_margin)
	}
	
	_choice_selector.step()
	
	if (_choice_selector.confirmed) {
		var _on_choice = pages[current_page][$ "on_choice"]
		if (!is_undefined(_on_choice)) _on_choice(_choice_selector.selected, _choices[_choice_selector.selected])
		
		dialogue_next_page()
	}
} else if (global.keys_pressed.confirm && _text_done) {
	dialogue_next_page()
}