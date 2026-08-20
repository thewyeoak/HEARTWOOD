presenter.initialize()

pages_length = array_length(pages)
current_page = 0

page = undefined
_typewriter = noone
_choice_selector = noone

show_page = function(_index) {
	current_page = _index
	_choice_selector = noone

	page = dialogue_page_resolve(pages[_index], presenter.defaults_for(pages[_index]))
	presenter.page_changed(page)

	_typewriter = new typewriter(page)
}

next_page = function() {
	if (current_page + 1 < pages_length) {
		show_page(current_page + 1)
	} else {
		instance_destroy()
	}
}

show_page(0)