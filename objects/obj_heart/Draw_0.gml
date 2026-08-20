var _shaded = (mode == soul_mode.blue)

if (_shaded) {
    shader_set(sh_palette)
    shader_set_uniform_i(palette_colors, 3)
    texture_set_stage(palette_sampler, sprite_get_texture(spr_heart_palette, 0))
}

if (visage_alpha > 0) {
    draw_sprite_ext(sprite_index, image_index, x, y, visage_scale, visage_scale, image_angle, c_white, visage_alpha)
}

draw_self()

if (_shaded) {shader_reset()}