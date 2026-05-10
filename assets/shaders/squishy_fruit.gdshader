shader_type canvas_item;

uniform float strength : hint_range(0.0, 1.0) = 0.1;
uniform float speed : hint_range(0.0, 10.0) = 2.0;
uniform vec2 distortion_scale = vec2(1.0, 1.0);

void vertex() {
	// Effetto di oscillazione (wobble) costante o basato sull'impatto
	float time = TIME * speed;
	VERTEX.x += cos(time + VERTEX.y * distortion_scale.y) * strength * 10.0;
	VERTEX.y += sin(time + VERTEX.x * distortion_scale.x) * strength * 10.0;
}
