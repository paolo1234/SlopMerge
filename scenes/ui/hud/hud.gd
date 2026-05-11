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
	EventBus.cringe_warning.connect(_on_cringe_warning)
	
	score_label.text = str(GameManager.score)
	combo_label.modulate.a = 0.0
	
	_setup_warning_label()
	
	# Initial power-up states
	PowerUpManager.powerup_activated.connect(_on_powerup_activated)
	PowerUpManager.powerup_deactivated.connect(_on_powerup_deactivated)

func _setup_warning_label() -> void:
	warning_label = Label.new()
	add_child(warning_label)
	warning_label.text = "!!! CRINGE OVERLOAD !!!"
	warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	warning_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	warning_label.modulate.a = 0
	
	var settings = LabelSettings.new()
	settings.font_size = 72
	settings.font_color = Color.RED
	settings.outline_size = 18
	settings.outline_color = Color.BLACK
	settings.shadow_size = 20
	settings.shadow_color = Color(0.5, 0, 0, 0.7)
	warning_label.label_settings = settings
	
	warning_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
	warning_label.anchor_left = 0.5
	warning_label.anchor_right = 0.5
	warning_label.offset_left = -400
	warning_label.offset_right = 400
	warning_label.offset_top = 400
	warning_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
	warning_label.scale = Vector2(1, 1)
	warning_label.pivot_offset = Vector2(400, 50)

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

func _on_cringe_warning(active: bool, _progress: float) -> void:
	if active:
		warning_label.visible = true
		warning_label.modulate.a = lerp(warning_label.modulate.a, 1.0, 0.1)
		var pulse = 1.0 + sin(Time.get_ticks_msec() * 0.02) * 0.15
		warning_label.scale = Vector2(pulse, pulse)
	else:
		warning_label.modulate.a = lerp(warning_label.modulate.a, 0.0, 0.2)
		if warning_label.modulate.a < 0.01:
			warning_label.visible = false

func _on_pause_pressed() -> void:
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
