_typewriter.step()

var _text_done = _typewriter.is_done()

presenter.step(page, !_text_done)

if (_text_done && !is_undefined(page.choices)) {
	if (_choice_selector == noone) {
		_choice_selector = presenter.make_choice_selector(page.choices, page.choice_inputs)
	}

	_choice_selector.step()

	if (_choice_selector.confirmed) {
		if (!is_undefined(page.on_choice)) page.on_choice(_choice_selector.selected, page.choices[_choice_selector.selected])

		next_page()
	}
} else if (global.keys_pressed.confirm && _text_done) {
	next_page()
}