extends Node

## Centralized utility to handle all fruit-related visual operations.
## Prevents code duplication across Spawner, NextQueue, and Fruit.

func get_region(fruit_id: int) -> Rect2:
	var layout = GameManager.active_layout
	if not layout:
		return Rect2()
		
	var sprite_key = layout.get_sprite_for_fruit(fruit_id)
	if sprite_key != "":
		return layout.get_region_by_name(sprite_key)
	else:
		return layout.get_region(fruit_id - 1, 0)

func setup_sprite(sprite: Sprite2D, fruit_id: int, radius: float = -1.0) -> void:
	var layout = GameManager.active_layout
	if not layout or not layout.texture: return
	
	sprite.texture = layout.texture
	sprite.region_enabled = true
	sprite.region_rect = get_region(fruit_id)
	
	if radius > 0:
		var actual_w = sprite.region_rect.size.x
		if actual_w <= 0: actual_w = layout.get_frame_size().x
		
		# Apply custom scale from layout if any
		var sprite_key = layout.get_sprite_for_fruit(fruit_id)
		var custom_scale = layout.get_custom_scale(sprite_key) if sprite_key != "" else 1.0
		
		var target_size = radius * 2.0 * custom_scale
		var scale_factor = target_size / actual_w
		
		if not (is_inf(scale_factor) or is_nan(scale_factor) or scale_factor <= 0):
			sprite.scale = Vector2(scale_factor, scale_factor)

func setup_texture_rect(target: TextureRect, fruit_id: int) -> void:
	var layout = GameManager.active_layout
	if not layout or not layout.texture: return
	
	var atlas = AtlasTexture.new()
	atlas.atlas = layout.texture
	atlas.region = get_region(fruit_id)
	target.texture = atlas

func apply_skin(sprite: CanvasItem, skin_name: String) -> void:
	match skin_name:
		"Gold":
			sprite.modulate = Color(1.2, 1.1, 0.2, 1.0)
		"Zombie":
			sprite.modulate = Color(0.5, 0.8, 0.5, 1.0)
		"Cyber":
			sprite.modulate = Color(0.2, 1.0, 1.2, 1.0)
		"Kawaii":
			sprite.modulate = Color(1.2, 0.6, 0.8, 1.0)
		"Edge":
			sprite.modulate = Color(0.3, 0.3, 0.3, 1.0)
		_:
			sprite.modulate = Color.WHITE
