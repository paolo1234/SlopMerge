shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.1, 0.1, 0.15, 1.0);
uniform vec4 color2 : source_color = vec4(0.15, 0.1, 0.2, 1.0);
uniform float speed : hint_range(0.0, 5.0) = 0.5;

void fragment() {
    float shift = sin(TIME * speed) * 0.5 + 0.5;
    vec4 final_color = mix(color1, color2, UV.y + shift * 0.2);
    
    // Add subtle glow patterns
    float noise = sin(UV.x * 10.0 + TIME) * cos(UV.y * 10.0 - TIME);
    final_color.rgb += noise * 0.02;
    
    COLOR = final_color;
}
