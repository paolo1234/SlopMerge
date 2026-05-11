extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.modulate.a = 0.0
	color_rect.hide()

func transition_to(scene_path: String) -> void:
	color_rect.show()
	var tween = create_tween()
	
	# Fade out
	await tween.tween_property(color_rect, "modulate:a", 1.0, 0.4).finished
	
	# Change scene
	get_tree().change_scene_to_file(scene_path)
	
	# Fade in
	var tween_in = create_tween()
	await tween_in.tween_property(color_rect, "modulate:a", 0.0, 0.4).finished
	
	color_rect.hide()
