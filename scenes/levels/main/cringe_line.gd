extends Area2D

@onready var visual: ColorRect = $Visual

var timer: float = 0.0
var is_active: bool = false
const LIMIT: float = 3.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	_update_visual(0.0)

func _on_body_entered(_body: Node2D) -> void:
	pass # Logic moved to _process for velocity check

func _on_body_exited(_body: Node2D) -> void:
	pass

func _process(delta: float) -> void:
	var danger_bodies = []
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			# Ignoriamo i frutti che stanno ancora salendo velocemente (appena sparati)
			if body.linear_velocity.y > -50.0: 
				danger_bodies.append(body)
	
	if danger_bodies.size() > 0:
		is_active = true
		timer += delta
		
		# Feedback visivo: intensità del rosso basata sul timer
		var alpha = 0.3 + (timer / LIMIT) * 0.5 + (sin(Time.get_ticks_msec() * 0.01) * 0.2)
		_update_visual(alpha)
		
		if timer >= LIMIT:
			get_node("/root/GameManager").game_over()
	else:
		is_active = false
		timer = 0.0
		_update_visual(0.2)

func _update_visual(alpha: float) -> void:
	var mat = visual.material as ShaderMaterial
	if mat:
		var color = Color(1.0, 0.0, 0.0, alpha)
		mat.set_shader_parameter("line_color", color)
