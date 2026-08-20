// created by python_b5 for undertale wildfire
// Draws text with special formatting (effects and colors).
function draw_formatted_text(x, y, font, char_spacing, line_spacing, text, alignment_horizontal = fa_left, alignment_vertical = fa_top) {
	draw_set_font(font)
	draw_set_halign(alignment_horizontal)
	draw_set_valign(alignment_vertical)
	
	var current_x = x
	var current_y = y
	
	var effect = undefined
	var shake_chance = undefined // it's maybe not the cleanest to have this separate, but it doesn't really matter
	
	// whether to indent new lines
	var auto_indent = (string_copy(text, 0, 2) == "* ")
	
	var text_length = string_length(text)
	for (var i = 1; i <= text_length; i++) {
		var char = string_char_at(text, i)
		
		if (char == "\n") {
			current_x = x
			current_y += line_spacing
			continue
		}
		
		// Check if a tag has been reached ("{{" for a literal "{")
		if (char == "{" && string_char_at(text, i + 1) != "{") {
			var tag = ""
			
			// read tag and move past it
			while (true) {
				char = string_char_at(text, ++i)
				
				if (char == "") {
					draw_set_color(c_white)
					return
				} else if (char == "}") {
					break
				} else {
					tag += char
				}
			}
			
			// process tag
			var arguments = string_split(tag, ",")
			var arguments_length = array_length(arguments)
			
			if (arguments_length == 2) {
				switch (arguments[0]) {
					case "e":
						switch (arguments[1]) {
							case "w":
								effect = text_effects.swirl
								break
							
							case "s":
								effect = text_effects.shake
								shake_chance = 2 / 3
								break
                            
                            case "ud":
								effect = text_effects.up_down
								shake_chance = 2 / 3
								break
							
							case "n":
								effect = undefined
								break
						}
						
						break
					
					case "c":
						switch (arguments[1]) {
							case "r":
								draw_set_color(c_red)
								break
							case "gr":
								draw_set_color(c_lime)
								break
							case "w":
								draw_set_color(c_white)
								break
							case "y":
								draw_set_color(c_yellow)
								break
							case "bk":
								draw_set_color(c_black)
								break
							case "bl":
								draw_set_color(c_blue)
								break
							case "o":
								draw_set_color(c_orange)
								break
							case "lb":
								draw_set_color(#0ec0fd)
								break
							case "f":
								draw_set_color(c_fuchsia)
								break
							case "p":
								draw_set_color(#ffbbd4)
								break
							case "gy":
								draw_set_color(c_gray)
								break
						}
                        
						break
				}
			} else if (arguments_length == 3 && arguments[0] == "e" && arguments[1] == "s") {
				var parts = string_split(arguments[2], "/", 1)
				if (
					string_length(string_digits(parts[0])) == string_length(parts[0])
					&& string_length(string_digits(parts[1])) == string_length(parts[1])
				) {
					var numerator = real(parts[0])
					var denominator = real(parts[1])
					
					// make sure it's a valid fraction and greater than zero
					if (numerator <= denominator && numerator > 0 && denominator > 0) {
// we have to do this check last to avoid potentially dividing by zero
						// shake_chance just won't be used if the check fails
						shake_chance = numerator / denominator
						if (shake_chance <= 1) {
							effect = text_effects.shake
						}
					}
				}
			}
			
			continue
		}
		
// handle effects
		// tODO: Make these look more like Undertale's
		var effect_x = 0
		var effect_y = 0
		
// hardcoding this into the text system feels gross
		// it's probably the least terrible way to do this, though
		//var battle_shake = false
		//if (room == rm_battle && is_undefined(effect)) {
			//effect = text_effects.shake
			//shake_chance = 1 / 1000
			//battle_shake = true
		//}
		
		switch (effect) {
			case text_effects.swirl:
				var angle = 360 - 10 * (global.time % 36)
				effect_x = round(lengthdir_x(2, (angle - (15 * i))))
				effect_y = round(lengthdir_y(2, (angle - (15 * i))))
			break
        
            case text_effects.up_down:
				var angle = 360 - 10 * (global.time % 36)
				effect_y = round(lengthdir_y(2, (angle - (15 * i))))
			break
			
			case text_effects.shake:
				// separate chances for each axis
				if (random(1) <= shake_chance) {
					effect_x = choose(-1, 1)
				}
				
				if (random(1) <= shake_chance) {
					effect_y = choose(-1, 1)
				}
			break
		}
		
		//if (battle_shake) {
			//effect = undefined
		//}
		
		draw_text(current_x + effect_x, current_y + effect_y, char)
		
		// faux bold effect for speech bubble text
		if (font == fnt_dialogue_battle) {	
			draw_text(current_x + effect_x + 1, current_y + effect_y, char)
		}
		
		current_x += char_spacing
	}
	
	draw_set_color(c_white)
}
    
// wraps text to a specific length, ignoring any formatting tags
    
function wrap_formatted_text(text, line_length, add_asterisks) {
	var wrapped_text = ""
	
	if (add_asterisks) {
		wrapped_text += "* "
		line_length -= 2 // the intentation from the asterisks means we have to wrap to a shorter length
	}
	
	var current_line_length = 0
	var delay = 1 // keep track of the character delay so we can reset it after wrapping indented lines
	
	var text_length = string_length(text)
	for (var i = 1; i <= text_length; i++) {
		var char = string_char_at(text, i)
		
		if (char == " ") {
			// start a new line if the next word will exceed the maximum line length
			// (j is allowed to go past text_length so that the final word can still be wrapped)
			var lookahead_length = 1
			
			for (var j = i + 1; j <= text_length + 1; j++) {
				var lookahead_char = string_char_at(text, j)
				
				if (lookahead_char == " " || lookahead_char == "\n" || lookahead_char == "") {
					if (current_line_length + lookahead_length > line_length) {
						wrapped_text += "\n"
						
						if (add_asterisks) {
// skip the delays between these characters so there's not an unnaturally long
// pause when using this text in a typewriter
// if this text isn't being used in a typewriter, these tags will do nothing - so no
							// harm done
							wrapped_text += "{d,0}  {d," + string(delay) + "}"
						}
						
						current_line_length = 0
					} else {
// the space still hasn't been added to the string, so add it here if we don't need to
						// start a new line
						wrapped_text += " "
						current_line_length++
					}
					
					break
				} else if (lookahead_char == "{") {
					if (string_char_at(text, j + 1) == "{") {
						// handle escaped "{"s
						lookahead_length++
						j++
					} else {
						// skip past tag
						while (string_char_at(text, ++j) != "}") {}
						j--
					}
				} else {
					lookahead_length++
				}
			}
		} else if (char == "{") {
			if (string_char_at(text, i + 1) == "{") {
				// handle escaped "{"s
				wrapped_text += char
				current_line_length++
				i++
			} else {
				// skip past tag
				wrapped_text += char
				var tag = ""
				
				do {
					char = string_char_at(text, ++i)
					wrapped_text += char
					
					if (char != "}") {
						tag += char
					}
				} until (char == "}")
				
				// no need to do this if we aren't adding asterisks
				if (add_asterisks) {
					var parts = string_split(tag, ",")
					if (array_length(parts) == 2 && parts[0] == "d" && string_length(string_digits(parts[1])) == string_length(parts[1])) {
						delay = real(parts[1])
					}
				}
			}
		} else {
			wrapped_text += char
			
    		// handle intentional newlines
    		if (char == "\n") {
    			if (add_asterisks) {
    				wrapped_text += "* "
    			}
    			
    			current_line_length = 0
    		} else {
    		    current_line_length++
    		}
		}
	}
	
	return wrapped_text
}