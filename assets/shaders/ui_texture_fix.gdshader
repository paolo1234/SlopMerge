shader_type canvas_item;

uniform bool remove_background = true;
uniform float mask_radius : hint_range(0.0, 1.0) = 0.48;
uniform float feather : hint_range(0.0, 0.5) = 0.02;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	
	if (remove_background) {
		float dist = distance(UV, vec2(0.5, 0.5));
		float mask = smoothstep(mask_radius + feather, mask_radius, dist);
		color.a *= mask;
		
		float diff = max(max(abs(color.r - color.g), abs(color.g - color.b)), abs(color.b - color.r));
		bool is_neutral = diff < 0.15; 
		float brightness = (color.r + color.g + color.b) / 3.0;
		
		if (is_neutral) {
			if (brightness > 0.88 || 
			   (brightness > 0.72 && brightness < 0.78) || 
			   (brightness > 0.58 && brightness < 0.64) || 
			   (brightness > 0.48 && brightness < 0.54) ||
			   (brightness > 0.38 && brightness < 0.44) ||
			   brightness < 0.12) {
				color.a = 0.0;
			}
		}
	}
	
	COLOR = color;
}
