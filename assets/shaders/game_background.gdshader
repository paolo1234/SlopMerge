shader_type canvas_item;

uniform vec4 color1 : source_color = vec4(0.05, 0.05, 0.08, 1.0);
uniform vec4 color2 : source_color = vec4(0.1, 0.05, 0.15, 1.0);
uniform float speed : hint_range(0.0, 2.0) = 0.2;

void fragment() {
	float noise = sin(FRAGCOORD.x * 0.01 + TIME * speed) * cos(FRAGCOORD.y * 0.01 + TIME * speed * 0.5);
	vec4 final_color = mix(color1, color2, noise * 0.5 + 0.5);
	
	// Subtle vignette
	float dist = distance(UV, vec2(0.5));
	final_color.rgb *= 1.0 - smoothstep(0.2, 1.2, dist);
	
	COLOR = final_color;
}
