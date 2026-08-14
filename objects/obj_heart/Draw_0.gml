var _colors = shader_get_uniform(sh_palette, "colors")
var _palettes = shader_get_sampler_index(sh_palette, "palettes")

switch (mode) {
    case soul_mode.blue:
        shader_set(sh_palette)
        shader_set_uniform_i(_colors, 3)
        texture_set_stage(_palettes, sprite_get_texture(spr_heart_palette, 0))
    break
}

draw_self()
shader_reset()