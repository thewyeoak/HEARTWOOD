enum directions {
    up,
    down,
    left,
    right
}

enum text_effects {
	swirl,  // characters move in circles
	shake, // characters move around sporadically
    up_down // similar to wave, but only on y Axis
}

enum data_types {
    bool,
    integer,
    real,
    string
}

enum soul_mode {
    battle,
    overworld,
    blue
}

enum easing {
	linear,
	
	in_sine,
	out_sine,
	inout_sine,
	
	in_cubic,
	out_cubic,
	inout_cubic,
	
	in_quint,
	out_quint,
	inout_quint,
	
	in_circ,
	out_circ,
	inout_circ,
	
	in_elastic,
	out_elastic,
	inout_elastic,
	
	in_quad,
	out_quad,
	inout_quad,
	
	in_quart,
	out_quart,
	inout_quart,
	
	in_expo,
	out_expo,
	inout_expo,
	
	in_back,
	out_back,
	inout_back,
	
	in_bounce,
	out_bounce,
	inout_bounce
}