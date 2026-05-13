extends Control

@onready var progress_bar: ProgressBar = $ProgressBar
@onready var ready_label: Label = $ReadyLabel

var current_value: float = 0.0
var is_ready: bool = false
var pulse_tween: Tween

func _ready() -> void:
	EventBus.brainrot_meter_updated.connect(_on_meter_updated)
	EventBus.brainrot_ready.connect(_trigger_ready_effect)
	progress_bar.value = 0
	ready_label.visible = false

func _on_meter_updated(value: float) -> void:
	current_value = value
	var tween = create_tween()
	tween.tween_property(progress_bar, "value", current_value, 0.3).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	
	if current_value < 100.0 and is_ready:
		_reset_ready_effect()

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
	GameManager.brainrot_energy = 0.0 # Sync back to manager
	_reset_ready_effect()
	
	# Access fruits via GameManager's cached container
	var fruits_container = GameManager.fruits_container
	var count = 0
	if fruits_container:
		for fruit in fruits_container.get_children():
			# Verifichiamo il tier tramite data.id
			if fruit.get("data") and fruit.data.id <= 2:
				fruit.queue_free()
				count += 1
	
	# Shake effect via EventBus
	EventBus.screen_shake_requested.emit(30.0)
	
	# VFX
	var vfx_scene = load("res://scenes/vfx/skibidi_blast_vfx.tscn")
	var vfx = vfx_scene.instantiate() as CPUParticles2D
	get_tree().root.add_child(vfx)
	vfx.global_position = Vector2(540, 960)
	vfx.emitting = true
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("explosion") 
	
	EventBus.special_ability_triggered.emit("blast", count)
	
	await get_tree().create_timer(2.0).timeout
	vfx.queue_free()
