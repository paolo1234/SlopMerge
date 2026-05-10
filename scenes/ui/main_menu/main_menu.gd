extends Control

func _ready() -> void:
	$VBoxContainer/PlayButton.pressed.connect(_on_play_pressed)
	$VBoxContainer/GachaButton.pressed.connect(_on_gacha_pressed)
	$VBoxContainer/SlopdexButton.pressed.connect(_on_slopdex_pressed)
	$VBoxContainer/WardrobeButton.pressed.connect(_on_wardrobe_pressed)
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
			btn.mouse_entered.connect(func(): 
				create_tween().tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_BACK)
			)
			btn.mouse_exited.connect(func(): 
				create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BACK)
			)

func _on_play_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/levels/main/main.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/levels/main/main.tscn")

func _on_gacha_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/gacha/gacha.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/gacha/gacha.tscn")

func _on_slopdex_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/slopdex/slopdex.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/slopdex/slopdex.tscn")

func _on_wardrobe_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/wardrobe/wardrobe.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/wardrobe/wardrobe.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
