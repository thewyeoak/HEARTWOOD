/// @param {Id.Instance,Struct} target       instance id or struct to modify
/// @param {String} variable                 name of the variable to ease, e.g. "x"
/// @param {Real} target_value               value to ease towards
/// @param {Real} duration                   duration in seconds
/// @param {Real} ease_type                  type of ease as specified in easing enums
/// @param {Function} [on_complete]          optional method, runs once the ease finishes naturally
function ease_start(_target, _variable, _target_value, _duration, _ease_type, _callback = undefined) {
    init_easers();

    var _exists = is_struct(_target)
        ? variable_struct_exists(_target, _variable)
        : variable_instance_exists(_target, _variable);

    if (!_exists) {
        _target[$ _variable] = _target_value;
    }

    if (_duration <= 0) {
        _target[$ _variable] = _target_value;
        var _instant_index = ease_find_index(_target, _variable);
        if (_instant_index != -1) array_delete(global.easers, _instant_index, 1);
        if (!is_undefined(_callback)) _callback();
        return undefined;
    }

    var _current_value = _target[$ _variable];
    var _index = ease_find_index(_target, _variable);

    var _ease_data = {
        target: _target,
        variable: _variable,
        start_value: _current_value,
        end_value: _target_value,
        duration: _duration,
        elapsed: 0,
        ease_type: _ease_type,
        callback: _callback
    };

    if (_index != -1) {
        global.easers[_index] = _ease_data; // overwrite in place; retarget from current value
    } else {
        array_push(global.easers, _ease_data);
    }

    return _ease_data;
}

/// @description Eases target.x and target.y together.
function ease_position(_target, _x, _y, _duration, _ease_type, _callback = undefined) {
    ease_start(_target, "x", _x, _duration, _ease_type);
    ease_start(_target, "y", _y, _duration, _ease_type, _callback);
}

/// @description Eases image_xscale and image_yscale together. Pass the same value twice for uniform scaling.
function ease_size(_target, _xscale, _yscale, _duration, _ease_type, _callback = undefined) {
    ease_start(_target, "image_xscale", _xscale, _duration, _ease_type);
    ease_start(_target, "image_yscale", _yscale, _duration, _ease_type, _callback);
}

/// @description Eases image_alpha.
function ease_alpha(_target, _alpha, _duration, _ease_type, _callback = undefined) {
    ease_start(_target, "image_alpha", _alpha, _duration, _ease_type, _callback);
}

/// @description Stops easing `variable` on `target`. Pass true for snap_to_end to jump straight to the target value; otherwise it just stops wherever it currently sits.
function ease_cancel(_target, _variable, _snap_to_end = false) {
    var _index = ease_find_index(_target, _variable);
    if (_index == -1) return false;

    if (_snap_to_end) {
        var _e = global.easers[_index];
        _e.target[$ _e.variable] = _e.end_value;
    }

    array_delete(global.easers, _index, 1);
    return true;
}

function ease_is_active(_target, _variable) {
    return ease_find_index(_target, _variable) != -1;
}

function ease_get_progress(_target, _variable) {
    var _index = ease_find_index(_target, _variable);
    if (_index == -1) return 1;
    var _e = global.easers[_index];
    return clamp(_e.elapsed / _e.duration, 0, 1);
}

function update_easers() {
    init_easers();

    var _dt = delta_time / 1000000; // delta_time in microseconds

    for (var _i = array_length(global.easers) - 1; _i >= 0; _i--) {
        var _e = global.easers[_i];

        if (!ease_target_valid(_e.target)) {
            array_delete(global.easers, _i, 1);
            continue;
        }

        _e.elapsed += _dt;
        var _t = clamp(_e.elapsed / _e.duration, 0, 1);
        var _eased_t = ease_calculate(_e.ease_type, _t);

        _e.target[$ _e.variable] = lerp(_e.start_value, _e.end_value, _eased_t);

        if (_t >= 1) {
            _e.target[$ _e.variable] = _e.end_value; // guarantee an exact final value
            array_delete(global.easers, _i, 1);
            if (!is_undefined(_e.callback)) _e.callback();
        }
    }
}

function ease_system_clear() {
    init_easers();
    global.easers = [];
}

function init_easers() {
    if (variable_global_exists("easers")) return;
    global.easers = [];
}

function ease_find_index(_target, _variable) {
    for (var _i = 0; _i < array_length(global.easers); _i++) {
        var _e = global.easers[_i];
        if (_e.target == _target && _e.variable == _variable) return _i;
    }
    return -1;
}

function ease_target_valid(_target) {
    if (is_struct(_target)) return true;
    return instance_exists(_target);
}

function ease_calculate(_type, _t) {
    switch (_type) {
        case easing.linear: return _t;

        // --- sine ---
        case easing.in_sine:    return 1 - cos((_t * pi) / 2);
        case easing.out_sine:   return sin((_t * pi) / 2);
        case easing.inout_sine: return -(cos(pi * _t) - 1) / 2;

        // --- quad ---
        case easing.in_quad:  return _t * _t;
        case easing.out_quad: return 1 - (1 - _t) * (1 - _t);
        case easing.inout_quad:
            return (_t < 0.5) ? 2 * _t * _t : 1 - power(-2 * _t + 2, 2) / 2;

        // --- cubic ---
        case easing.in_cubic:  return _t * _t * _t;
        case easing.out_cubic: return 1 - power(1 - _t, 3);
        case easing.inout_cubic:
            return (_t < 0.5) ? 4 * _t * _t * _t : 1 - power(-2 * _t + 2, 3) / 2;

        // --- quart ---
        case easing.in_quart:  return power(_t, 4);
        case easing.out_quart: return 1 - power(1 - _t, 4);
        case easing.inout_quart:
            return (_t < 0.5) ? 8 * power(_t, 4) : 1 - power(-2 * _t + 2, 4) / 2;

        // --- quint ---
        case easing.in_quint:  return power(_t, 5);
        case easing.out_quint: return 1 - power(1 - _t, 5);
        case easing.inout_quint:
            return (_t < 0.5) ? 16 * power(_t, 5) : 1 - power(-2 * _t + 2, 5) / 2;

        // --- expo ---
        case easing.in_expo:  return (_t <= 0) ? 0 : power(2, 10 * _t - 10);
        case easing.out_expo: return (_t >= 1) ? 1 : 1 - power(2, -10 * _t);
        case easing.inout_expo:
            if (_t <= 0) return 0;
            if (_t >= 1) return 1;
            return (_t < 0.5) ? power(2, 20 * _t - 10) / 2 : (2 - power(2, -20 * _t + 10)) / 2;

        // --- circ ---
        case easing.in_circ:  return 1 - sqrt(1 - power(_t, 2));
        case easing.out_circ: return sqrt(1 - power(_t - 1, 2));
        case easing.inout_circ:
            return (_t < 0.5)
                ? (1 - sqrt(1 - power(2 * _t, 2))) / 2
                : (sqrt(1 - power(-2 * _t + 2, 2)) + 1) / 2;

        // --- back ---
        case easing.in_back: {
            var _c1 = 1.70158;
            var _c3 = _c1 + 1;
            return _c3 * _t * _t * _t - _c1 * _t * _t;
        }
        case easing.out_back: {
            var _c1 = 1.70158;
            var _c3 = _c1 + 1;
            return 1 + _c3 * power(_t - 1, 3) + _c1 * power(_t - 1, 2);
        }
        case easing.inout_back: {
            var _c1 = 1.70158;
            var _c2 = _c1 * 1.525;
            return (_t < 0.5)
                ? (power(2 * _t, 2) * ((_c2 + 1) * 2 * _t - _c2)) / 2
                : (power(2 * _t - 2, 2) * ((_c2 + 1) * (_t * 2 - 2) + _c2) + 2) / 2;
        }

        // --- elastic ---
        case easing.in_elastic: {
            if (_t <= 0) return 0;
            if (_t >= 1) return 1;
            var _c4 = (2 * pi) / 3;
            return -power(2, 10 * _t - 10) * sin((_t * 10 - 10.75) * _c4);
        }
        case easing.out_elastic: {
            if (_t <= 0) return 0;
            if (_t >= 1) return 1;
            var _c4 = (2 * pi) / 3;
            return power(2, -10 * _t) * sin((_t * 10 - 0.75) * _c4) + 1;
        }
        case easing.inout_elastic: {
            if (_t <= 0) return 0;
            if (_t >= 1) return 1;
            var _c5 = (2 * pi) / 4.5;
            return (_t < 0.5)
                ? -(power(2, 20 * _t - 10) * sin((20 * _t - 11.125) * _c5)) / 2
                : (power(2, -20 * _t + 10) * sin((20 * _t - 11.125) * _c5)) / 2 + 1;
        }

        // --- bounce ---
        case easing.out_bounce: return ease_out_bounce(_t);
        case easing.in_bounce:  return 1 - ease_out_bounce(1 - _t);
        case easing.inout_bounce:
            return (_t < 0.5)
                ? (1 - ease_out_bounce(1 - 2 * _t)) / 2
                : (1 + ease_out_bounce(2 * _t - 1)) / 2;

        default: return _t; // if unrecognised fallback to linear ease
    }
}

function ease_out_bounce(_t) {
    var _n1 = 7.5625;
    var _d1 = 2.75;

    if (_t < 1 / _d1) {
        return _n1 * _t * _t;
    } else if (_t < 2 / _d1) {
        _t -= 1.5 / _d1;
        return _n1 * _t * _t + 0.75;
    } else if (_t < 2.5 / _d1) {
        _t -= 2.25 / _d1;
        return _n1 * _t * _t + 0.9375;
    } else {
        _t -= 2.625 / _d1;
        return _n1 * _t * _t + 0.984375;
    }
}