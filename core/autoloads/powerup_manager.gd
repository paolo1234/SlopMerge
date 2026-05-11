extends Node

signal powerup_activated(type: String)
signal powerup_deactivated(type: String)

var is_slow_mo: bool = false
var slow_mo_factor: float = 0.3
var slow_mo_duration: float = 3.0

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
