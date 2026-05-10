extends Control

@onready var score_label: Label = %ScoreLabel
@onready var combo_label: Label = %ComboLabel

var combo_tween: Tween

func _ready() -> void:
	var gm = get_node("/root/GameManager")
	gm.score_changed.connect(_on_score_changed)
	gm.combo_changed.connect(_on_combo_changed)
	score_label.text = str(gm.score)
	combo_label.modulate.a = 0.0

func _on_score_changed(new_score: int) -> void:
	score_label.text = str(new_score)
	# Effetto pop sul punteggio
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
		# Svanisce se la combo torna a 1
		var tween = create_tween()
		tween.tween_property(combo_label, "modulate:a", 0.0, 0.5)

func _on_pause_pressed() -> void:
	var pause_menu_scene = load("res://scenes/ui/pause_menu/pause_menu.tscn")
	var instance = pause_menu_scene.instantiate()
	get_tree().root.add_child(instance)
