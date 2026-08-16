if (visible_heart) {
    draw_self()
}

if (gameover_alpha > 0) {
    draw_sprite_ext(spr_gameover, 0, 111, 33, 1, 1, 0, c_white, gameover_alpha)
}