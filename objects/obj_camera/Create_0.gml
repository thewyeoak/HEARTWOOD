focus = undefined
found_player = false

mod_x = 0
mod_y = 0

shake_magnitude = 0
shake_decay = 0

view_width = 320
view_height = 240

focus_offset_x = view_width / 2
// sits below center so there's more room above the player than below
focus_offset_y = view_height / 2 + 15

function apply_shake(_magnitude, _decay) {
    if (_magnitude > shake_magnitude) {
        shake_magnitude = _magnitude
        shake_decay = _decay
    }
}