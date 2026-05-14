extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.modulate.a = 0.0
	color_rect.hide()

func transition_to(scene_path: String) -> void:
	color_rect.show()
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	# Fade out
	tween.tween_property(color_rect, "modulate:a", 1.0, 0.4)
	await tween.finished
	
	# Change scene
	get_tree().paused = false
	get_tree().change_scene_to_file(scene_path)
	
	# Wait for the next frame to ensure the scene is loaded
	await get_tree().process_frame
	
	# Fade in
	var tween_in = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween_in.tween_property(color_rect, "modulate:a", 0.0, 0.4)
	await tween_in.finished
	
	color_rect.hide()
