extends Label

func _ready() -> void:
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	modulate.a = 0
	visible = false
	
	EventBus.cringe_warning.connect(_on_cringe_warning)

func _process(_delta: float) -> void:
	if visible and modulate.a > 0.1:
		var pulse = 1.0 + sin(Time.get_ticks_msec() * 0.02) * 0.15
		scale = Vector2(pulse, pulse)

func _on_cringe_warning(active: bool, _progress: float) -> void:
	if active:
		visible = true
		create_tween().tween_property(self, "modulate:a", 1.0, 0.2)
	else:
		var tween = create_tween()
		tween.tween_property(self, "modulate:a", 0.0, 0.3)
		tween.finished.connect(func(): visible = false)
