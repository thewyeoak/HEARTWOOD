var _colors = shader_get_uniform(sh_palette, "colors")
var _palettes = shader_get_sampler_index(sh_palette, "palettes")

switch (mode) {
    case soul_mode.blue:
        shader_set(sh_palette)
        shader_set_uniform_i(_colors, 3)
        texture_set_stage(_palettes, sprite_get_texture(spr_heart_palette, 0))
    break
}

if (visage_alpha > 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, visage_scale, visage_scale, image_angle, c_white, visage_alpha)
}

draw_self()
shader_reset()