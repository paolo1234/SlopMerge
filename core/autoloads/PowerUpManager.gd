extends Node

signal powerup_activated(type: String)
signal powerup_deactivated(type: String)

var is_slow_mo: bool = false
var slow_mo_factor: float = 0.3
var slow_mo_duration: float = 3.0

var brainrot_energy: float = 0.0
const MAX_BRAINROT: float = 100.0

func _ready() -> void:
	EventBus.merge_occurred.connect(_on_merge_occurred)

func _on_merge_occurred(_pos: Vector2, tier: int) -> void:
	# Calcolo energia: basato su tier e combo (che ora prendiamo da ScoreManager)
	var combo = 1
	if has_node("/root/ScoreManager"):
		combo = get_node("/root/ScoreManager").combo_multiplier
		
	var energy_gain = float(tier) * (1.0 + (combo * 0.2))
	brainrot_energy = min(brainrot_energy + energy_gain, MAX_BRAINROT)
	EventBus.brainrot_meter_updated.emit(brainrot_energy)
	
	if brainrot_energy >= MAX_BRAINROT:
		EventBus.brainrot_ready.emit()

func activate_ultimate() -> void:
	if brainrot_energy < MAX_BRAINROT: return
	
	_trigger_skibidi_blast()

func _trigger_skibidi_blast() -> void:
	brainrot_energy = 0.0
	EventBus.brainrot_meter_updated.emit(0.0)
	
	var fruits_container = GameManager.fruits_container
	var count = 0
	if fruits_container:
		for fruit in fruits_container.get_children():
			if fruit.get("data") and fruit.data.id <= 2:
				fruit.queue_free()
				count += 1
	
	EventBus.screen_shake_requested.emit(30.0)
	
	# VFX
	if ResourceLoader.exists("res://scenes/vfx/skibidi_blast_vfx.tscn"):
		var vfx_scene = load("res://scenes/vfx/skibidi_blast_vfx.tscn")
		var vfx = vfx_scene.instantiate()
		get_tree().root.add_child(vfx)
		vfx.global_position = Vector2(540, 960)
		if vfx is CPUParticles2D: vfx.emitting = true
		
		get_tree().create_timer(2.0).timeout.connect(func(): vfx.queue_free())
	
	if has_node("/root/AudioManager"):
		AudioManager.play_sound("explosion") 
	
	EventBus.special_ability_triggered.emit("blast", count)

func activate_slow_mo() -> void:
	if is_slow_mo: return
	
	is_slow_mo = true
	Engine.time_scale = slow_mo_factor
	powerup_activated.emit("slow_mo")
	
	# Audio feedback if available
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("slow_down")
	
	await get_tree().create_timer(slow_mo_duration * slow_mo_factor).timeout
	deactivate_slow_mo()

func deactivate_slow_mo() -> void:
	if not is_slow_mo: return
	
	is_slow_mo = false
	Engine.time_scale = 1.0
	powerup_deactivated.emit("slow_mo")
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("speed_up")

func activate_magnet() -> void:
	# Magnet logic: attracts all fruits to the center for a short time
	powerup_activated.emit("magnet")
	
	var fruits = GameManager.fruits_container.get_children()
	for fruit in fruits:
		if fruit is RigidBody2D:
			# Apply a force towards the center
			var center = Vector2(540, 960) # Center of 1080x1920
			var dir = (center - fruit.global_position).normalized()
			fruit.apply_central_impulse(dir * 500.0)
	
	await get_tree().create_timer(1.0).timeout
	powerup_deactivated.emit("magnet")
