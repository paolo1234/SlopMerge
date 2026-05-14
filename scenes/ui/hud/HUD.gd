extends Control

@onready var score_label: Label = %ScoreLabel
@onready var combo_label: Label = %ComboLabel
@onready var magnet_button: Button = %MagnetButton
@onready var slow_mo_button: Button = %SlowMoButton

var combo_tween: Tween
var warning_label: Label

func _ready() -> void:
	EventBus.score_changed.connect(_on_score_changed)
	EventBus.combo_changed.connect(_on_combo_changed)
	
	if has_node("/root/ScoreManager"):
		score_label.text = str(ScoreManager.score)
	else:
		score_label.text = "0"
	combo_label.modulate.a = 0.0
	
	# Initial power-up states
	PowerUpManager.powerup_activated.connect(_on_powerup_activated)
	PowerUpManager.powerup_deactivated.connect(_on_powerup_deactivated)
	
	_setup_button_juice()

func _setup_button_juice() -> void:
	for btn in [magnet_button, slow_mo_button]:
		btn.pivot_offset = btn.size / 2
		btn.mouse_entered.connect(func(): create_tween().tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1))
		btn.mouse_exited.connect(func(): create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1))

func _on_score_changed(new_score: int) -> void:
	score_label.text = str(new_score)
	var tween = create_tween()
	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property(score_label, "scale", Vector2(1.0, 1.0), 0.1)

func _on_combo_changed(new_combo: int) -> void:
	if new_combo > 1:
		combo_label.text = "COMBO X" + str(new_combo)
		combo_label.modulate.a = 1.0
		
		if combo_tween: combo_tween.kill()
		combo_tween = create_tween()
		combo_tween.tween_property(combo_label, "scale", Vector2(1.3, 1.3), 0.1)
		combo_tween.tween_property(combo_label, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		var tween = create_tween()
		tween.tween_property(combo_label, "modulate:a", 0.0, 0.5)

func _on_pause_pressed() -> void:
	# Guard: Don't allow pause during game over or transitions
	if GameManager.is_game_over or TransitionManager.is_transitioning:
		return
		
	get_viewport().set_input_as_handled()
	var pause_menu_scene = load("res://scenes/ui/pause_menu/pause_menu.tscn")
	var instance = pause_menu_scene.instantiate()
	get_tree().root.add_child(instance)

func _on_magnet_pressed() -> void:
	PowerUpManager.activate_magnet()

func _on_slow_mo_pressed() -> void:
	PowerUpManager.activate_slow_mo()

func _on_powerup_activated(type: String) -> void:
	match type:
		"magnet":
			magnet_button.modulate = Color.CYAN
		"slow_mo":
			slow_mo_button.modulate = Color.YELLOW

func _on_powerup_deactivated(type: String) -> void:
	match type:
		"magnet":
			magnet_button.modulate = Color.WHITE
		"slow_mo":
			slow_mo_button.modulate = Color.WHITE
