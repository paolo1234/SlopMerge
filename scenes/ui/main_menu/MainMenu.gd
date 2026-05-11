extends Control

func _ready() -> void:
	if not $VBoxContainer/PlayButton.pressed.is_connected(_on_play_pressed):
		$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	if not $VBoxContainer/GachaButton.pressed.is_connected(_on_gacha_pressed):
		$VBoxContainer/GachaButton.pressed.connect(_on_gacha_pressed)
	if not $VBoxContainer/SlopdexButton.pressed.is_connected(_on_slopdex_pressed):
		$VBoxContainer/SlopdexButton.pressed.connect(_on_slopdex_pressed)
	if not $VBoxContainer/WardrobeButton.pressed.is_connected(_on_wardrobe_pressed):
		$VBoxContainer/WardrobeButton.pressed.connect(_on_wardrobe_pressed)
	if not $VBoxContainer/QuitButton.pressed.is_connected(_on_quit_pressed):
		$VBoxContainer/QuitButton.pressed.connect(_on_quit_pressed)
	
	_setup_juice()

func _setup_juice() -> void:
	# Pulse title
	var tween = create_tween().set_loops()
	tween.tween_property($Title, "scale", Vector2(1.05, 1.05), 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Title, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE)
	$Title.pivot_offset = $Title.size / 2
	
	# Button hover effects
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			btn.pivot_offset = btn.size / 2
			if not btn.mouse_entered.is_connected(_on_button_hover.bind(btn)):
				btn.mouse_entered.connect(_on_button_hover.bind(btn))
			if not btn.mouse_exited.is_connected(_on_button_unhover.bind(btn)):
				btn.mouse_exited.connect(_on_button_unhover.bind(btn))

func _on_button_hover(btn: Button) -> void:
	create_tween().tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_BACK)

func _on_button_unhover(btn: Button) -> void:
	create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BACK)

func _on_play_pressed() -> void:
	TransitionManager.transition_to("res://scenes/levels/main/main.tscn")

func _on_gacha_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/gacha/gacha.tscn")

func _on_slopdex_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/slopdex/slopdex.tscn")

func _on_wardrobe_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/wardrobe/wardrobe.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
