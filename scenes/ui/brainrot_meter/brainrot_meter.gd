extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ready_label: Label = $ReadyLabel

var current_value: float = 0.0
var is_ready: bool = false

func _ready() -> void:
	var gm = get_node("/root/GameManager")
	gm.chain_event.connect(_on_chain_event)
	progress_bar.value = 0
	ready_label.visible = false

func _on_chain_event(_pos: Vector2, count: int, bonus: float) -> void:
	current_value = clamp(current_value + bonus, 0.0, 100.0)
	
	# Effetto brainrot: la barra pulsa quando aumenta
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", current_value, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Se piena, attiviamo l'effetto visivo "Ready"
	if current_value >= 100.0 and not is_ready:
		_trigger_ready_effect()
	elif current_value < 100.0 and is_ready:
		_reset_ready_effect()
	
	# Shake effect proporzionale alla combo
	var intensity = clamp(count * 2.0, 5.0, 20.0)
	var original_pos = position
	var shake_tween = create_tween()
	for i in 4:
		shake_tween.tween_property(self, "position", original_pos + Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity)), 0.05)
	shake_tween.tween_property(self, "position", original_pos, 0.05)

func _trigger_ready_effect() -> void:
	is_ready = true
	ready_label.visible = true
	var tween = create_tween().set_loops()
	tween.tween_property(ready_label, "modulate:a", 1.0, 0.2)
	tween.tween_property(ready_label, "modulate:a", 0.5, 0.2)
	
	var bar_tween = create_tween().set_loops()
	bar_tween.tween_property(progress_bar, "modulate", Color(1.5, 1.5, 1.5, 1), 0.3)
	bar_tween.tween_property(progress_bar, "modulate", Color(1, 1, 1, 1), 0.3)

func _reset_ready_effect() -> void:
	is_ready = false
	ready_label.visible = false
	progress_bar.modulate = Color(1, 1, 1, 1)
