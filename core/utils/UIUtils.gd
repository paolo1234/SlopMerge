extends Node

## UIUtils: Centralized utility for consistent UI interactions and "Juice".
## Handles button scaling, common sounds, and standard transitions.

func setup_button(button: Button, scale_on_hover: float = 1.05) -> void:
	if not button: return
	
	# Initial setup
	button.pivot_offset = button.size / 2.0
	
	# Hover animation
	button.mouse_entered.connect(func():
		var tween = button.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "scale", Vector2(scale_on_hover, scale_on_hover), 0.2)
		if AudioManager.has_method("play_ui_sound"):
			AudioManager.play_ui_sound("hover")
	)
	
	# Unhover animation
	button.mouse_exited.connect(func():
		var tween = button.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "scale", Vector2.ONE, 0.2)
	)
	
	# Click animation & sound
	button.pressed.connect(func():
		var tween = button.create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		tween.tween_property(button, "scale", Vector2(0.9, 0.9), 0.1)
		tween.tween_property(button, "scale", Vector2.ONE, 0.2)
		if AudioManager.has_method("play_ui_sound"):
			AudioManager.play_ui_sound("click")
	)

func animate_pop_in(node: Control, delay: float = 0.0) -> void:
	node.scale = Vector2.ZERO
	node.pivot_offset = node.size / 2.0
	var tween = node.create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	if delay > 0:
		tween.tween_interval(delay)
	tween.tween_property(node, "scale", Vector2.ONE, 0.5)

func apply_button_theme(button: Button) -> void:
	# Placeholder for global theme application if needed later
	pass
