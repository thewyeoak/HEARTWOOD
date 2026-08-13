if (fade_alpha > 0) 
{
    draw_set_alpha(fade_alpha)
    draw_set_color(fade_color)
    
    draw_rectangle(0, 0, 640, 480, false)
    
    draw_set_alpha(1)
    draw_set_color(c_white)
}