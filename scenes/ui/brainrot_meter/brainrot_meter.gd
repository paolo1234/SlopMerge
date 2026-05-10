extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	get_node("/root/GameManager").score_changed.connect(_on_score_changed)
	progress_bar.value = 0

func _on_score_changed(new_score: int) -> void:
	# Effetto brainrot: la barra pulsa quando aumenta
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", float(new_score % 100), 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	# Shake effect
	var original_pos = position
	var shake_tween = create_tween()
	for i in 4:
		shake_tween.tween_property(self, "position", original_pos + Vector2(randf_range(-5, 5), randf_range(-5, 5)), 0.05)
	shake_tween.tween_property(self, "position", original_pos, 0.05)
