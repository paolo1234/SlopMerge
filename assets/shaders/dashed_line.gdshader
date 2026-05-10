shader_type canvas_item;

uniform float dash_size : hint_range(0.1, 50.0) = 10.0;
uniform float gap_size : hint_range(0.1, 50.0) = 5.0;
uniform vec4 line_color : source_color = vec4(1.0, 0.0, 0.0, 0.5);

void fragment() {
    float pos = UV.x * 1080.0; // Use viewport width
    if (mod(pos, dash_size + gap_size) > dash_size) {
        discard;
    }
    COLOR = line_color;
}
