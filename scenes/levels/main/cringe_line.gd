extends Area2D

@onready var visual: ColorRect = $Visual

var timer: float = 0.0
var is_active: bool = false
const LIMIT: float = 3.0

func _ready() -> void:
	_update_visual(0.0, 1.0)

func _process(delta: float) -> void:
	var danger_bodies: Array[Node2D] = []
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			if body.linear_velocity.y > -100.0: 
				danger_bodies.append(body)
	
	if danger_bodies.size() > 0:
		is_active = true
		timer += delta
		
		var progress: float = timer / LIMIT
		var alpha: float = 0.4 + progress * 0.6
		var shader_speed: float = 5.0 + progress * 15.0
		_update_visual(alpha, shader_speed)
		
		# Notify UI via EventBus
		EventBus.cringe_warning.emit(true, progress)
		
		if timer >= LIMIT:
			GameManager.game_over()
	else:
		if is_active:
			is_active = false
			EventBus.cringe_warning.emit(false, 0.0)
			
		timer = lerp(timer, 0.0, 0.1)
		_update_visual(0.2, 5.0)

func _update_visual(alpha: float, speed: float) -> void:
	var mat: ShaderMaterial = visual.material as ShaderMaterial
	if mat:
		var color: Color = Color(1.0, 0.0, 0.0, alpha)
		mat.set_shader_parameter("line_color", color)
		mat.set_shader_parameter("speed", speed)
