// created by python_b5 for undertale wildfire; edited by thewyeoak to add pitch support
// Creates a new typewriter ("types" characters out one at a time).
// takes a page that has already been through dialogue_page_resolve
function typewriter(_page) constructor {
	font = _page.font
	char_spacing = _page.char_spacing
	line_spacing = _page.line_spacing
	blip = _page.blip
	pitch_low = _page.pitch_low
	pitch_high = _page.pitch_high
	can_skip = _page.can_skip
	speaker = _page.speaker
	text = wrap_formatted_text(_page.text, _page.line_length, _page.add_asterisks)

	text_length = string_length(text)

	shown_chars = 0
	shown_text = ""

	delay = 1
	char_timer = delay

	auto_pause = true

	if (speaker != noone) {
		global.speaker = speaker
	}

	// scans for and parses as many tags as possible from the current text position
	static parse_tags = function() {
		var char = string_char_at(text, shown_chars + 1)
		var exclude = false

		while (char == "{") {
			shown_chars++

			if (string_char_at(text, shown_chars + 1) == "{") {
				// handle escaped "{"s
				shown_chars++
				break
			} else {
				// skip past and read tag
				shown_text += char
				var tag = ""

				do {
					char = string_char_at(text, ++shown_chars)
					shown_text += char

					if (char != "}") {
						tag += char
					}
				} until (char == "}")

				// handle tag
				var parts = string_split(tag, ",")
				if (array_length(parts) == 2) {
					if (string_digits(parts[1]) == parts[1]) {
						var number = real(parts[1])
						if (parts[0] == "d") { // change delay between characters
							delay = number
						} else if (parts[0] == "p" && number > 0) { // pause for a specific amount of frames
							char_timer += number
						}
					} else if (parts[0] == "a") {
						switch (parts[1]) {
							case "y":
								auto_pause = true
								break

							case "n":
								auto_pause = false
								break

							case "e":
								exclude = true
								break
						}
					}
				}

				// get the character after the tag
				char = string_char_at(text, shown_chars + 1)
			}
		}

		return (char == " " || char == "\n") && !exclude
	}

	parse_tags()

// performs the main logic of the typewriter
	// should be called once per frame
	static step = function() {
		if (can_skip && global.keys_pressed.cancel) {
			shown_chars = text_length
			shown_text = text
		} else if (shown_chars < text_length && --char_timer <= 0) {
			while (true) {
				var char = string_char_at(text, ++shown_chars)
				shown_text += char

				// we need this character later on to handle auto-pauses
				var auto_pause_char = char

				// play a voice blip on alphanumeric characters
				if (string_length(string_lettersdigits(char)) == 1 && blip != noone) {
					audio_sound_pitch(blip, random_range(pitch_low, pitch_high))
					audio_play_sound(blip, 1, false)
				}

				// parse_tags() returns whether we can auto-pause
				if (parse_tags() && auto_pause) {
					switch (auto_pause_char) {
						case ".":
						case "!":
						case "?":
						case ",":
						case ";":
						case ":":
						case "-":
							char_timer += delay * 5
							break
					}
				}

				if (shown_chars < text_length) {
					if (delay > 0) {
						char_timer += delay
						break
					}
				} else {
					break
				}
			}
		}

		if (shown_chars == text_length && speaker != noone) {
			global.speaker = noone
		}
	}

	// whether every character has been typed out
	static is_done = function() {
		return shown_chars == text_length
	}

	// draws the currently shown characters
	static draw = function(_x, _y) {
		draw_formatted_text(_x, _y, font, char_spacing, line_spacing, shown_text)
	}
}