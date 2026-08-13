varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform int colors;
uniform sampler2D palettes;

void main() {
    vec4 color = texture2D(gm_BaseTexture, v_vTexcoord);
    
    for (int i = 0; i < colors; i++) {
        if (distance(
            color.rgb,
            texture2D(palettes, vec2((float(i) + 0.5) / float(colors), 0.0)).rgb
        ) < 0.01) {
            color.rgb = texture2D(palettes, vec2((float(i) + 0.5) / float(colors), 0.5)).rgb;
            break;
        }
    }
    
    gl_FragColor = color * v_vColour;
}