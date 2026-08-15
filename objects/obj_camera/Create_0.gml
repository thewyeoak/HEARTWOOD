focus = undefined
found_player = false

mod_x = 0
mod_y = 0

shake_magnitude = 0; shake_decay = 0

function apply_shake(_magnitude, _decay) {
    if (_magnitude > shake_magnitude) {
        shake_magnitude = _magnitude;
        shake_decay = _decay;
    }
}