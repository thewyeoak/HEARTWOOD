//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float col_r;
uniform float col_g;
uniform float col_b;
uniform float col_a;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
    
    gl_FragColor.r += vec3(col_r);
    gl_FragColor.g += vec3(col_g);
    gl_FragColor.b += vec3(col_b);
    gl_FragColor.a += vec3(col_a);
}
