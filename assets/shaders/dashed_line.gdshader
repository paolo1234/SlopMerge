shader_type canvas_item;

uniform float dash_size : hint_range(1.0, 50.0) = 15.0;
uniform float gap_size : hint_range(1.0, 50.0) = 10.0;
uniform vec4 line_color : source_color = vec4(1.0, 0.0, 0.0, 1.0);
uniform float speed : hint_range(0.0, 10.0) = 5.0;

void fragment() {
	float pos = FRAGCOORD.x + TIME * speed * 20.0;
	float total = dash_size + gap_size;
	float val = mod(pos, total);
	
	if (val > dash_size) {
		discard;
	}
	
	// Pulsing effect
	float pulse = 0.6 + 0.4 * sin(TIME * speed);
	vec4 final_color = line_color;
	final_color.a *= pulse;
	
	// Glow effect
	float dist_center = abs(UV.y - 0.5);
	float glow = 1.0 - smoothstep(0.0, 0.5, dist_center);
	final_color.rgb *= (1.0 + glow * 2.0);
	
	COLOR = final_color;
}
