if (instance_exists(creator)) {
    var _mouth_offset = 30
    x = creator.x + lengthdir_x(_mouth_offset, image_angle)
    y = creator.y + lengthdir_y(_mouth_offset, image_angle)
}

switch (state) {
    case "fire":
        image_yscale = lerp(image_yscale, max_thickness, 0.6)
    break
        
    case "fade":
        image_yscale = lerp(image_yscale, 0, 0.2)
        image_alpha -= 0.1
        
        if (image_alpha <= 0) {
            instance_destroy()
        }
    break
}