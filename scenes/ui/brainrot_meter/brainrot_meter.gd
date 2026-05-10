extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ready_label: Label = $ReadyLabel

var current_value: float = 0.0
var is_ready: bool = false
var pulse_tween: Tween

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
	
	if pulse_tween: pulse_tween.kill()
	pulse_tween = create_tween().set_loops().set_parallel(true)
	pulse_tween.tween_property(ready_label, "modulate:a", 1.0, 0.3)
	pulse_tween.tween_property(ready_label, "scale", Vector2(1.2, 1.2), 0.3)
	pulse_tween.chain().tween_property(ready_label, "modulate:a", 0.5, 0.3)
	pulse_tween.tween_property(ready_label, "scale", Vector2(1.0, 1.0), 0.3)
	
	var bar_tween = create_tween().set_loops()
	bar_tween.tween_property(progress_bar, "modulate", Color(1.5, 1.5, 1.5, 1), 0.3)
	bar_tween.tween_property(progress_bar, "modulate", Color(1, 1, 1, 1), 0.3)

func _reset_ready_effect() -> void:
	is_ready = false
	ready_label.visible = false
	if pulse_tween: pulse_tween.kill()
	progress_bar.modulate = Color(1, 1, 1, 1)

func _on_ultimate_pressed() -> void:
	if is_ready:
		_trigger_skibidi_blast()

func _trigger_skibidi_blast() -> void:
	print("SKIBIDI BLAST ACTIVATED!")
	current_value = 0.0
	progress_bar.value = 0.0
	_reset_ready_effect()
	
	# Trova tutti i frutti e distruggi quelli di basso rango (0, 1, 2)
	var fruits_container = get_node("/root/Main/FruitsContainer")
	var count = 0
	for fruit in fruits_container.get_children():
		if fruit.has_method("get_rank") and fruit.get_rank() <= 2:
			# Effetto particellare opzionale qui
			fruit.queue_free()
			count += 1
	
	# Effetto screen shake
	var cam = get_viewport().get_camera_2d()
	if cam and cam.has_method("shake"):
		cam.shake(30.0, 0.5)
	
	# Istanzia VFX dell'esplosione
	var vfx_scene = load("res://scenes/vfx/skibidi_blast_vfx.tscn")
	var vfx = vfx_scene.instantiate() as CPUParticles2D
	get_tree().root.add_child(vfx)
	vfx.global_position = Vector2(540, 960) # Centro schermo
	vfx.emitting = true
	
	# Notifica AudioManager per un suono potente
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("explosion") 
	
	# Notifica GameManager per effetti sonori/particelle globali
	var gm = get_node("/root/GameManager")
	if gm.has_signal("special_ability_triggered"):
		gm.emit_signal("special_ability_triggered", "blast", count)
	
	# Timer per rimuovere il VFX
	await get_tree().create_timer(2.0).timeout
	vfx.queue_free()
