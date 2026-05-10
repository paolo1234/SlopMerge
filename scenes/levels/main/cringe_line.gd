extends Area2D

@onready var visual: ColorRect = $Visual

var timer: float = 0.0
var is_active: bool = false
const LIMIT: float = 3.0

var warning_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Create a warning label dynamically
	warning_label = Label.new()
	add_child(warning_label)
	warning_label.text = "!!! CRINGE OVERLOAD !!!"
	warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	warning_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	warning_label.modulate.a = 0
	warning_label.scale = Vector2(2, 2)
	warning_label.pivot_offset = Vector2(100, 15) # Center pivot
	warning_label.position = Vector2(540 - 100, -100) # Above the line
	
	var settings = LabelSettings.new()
	settings.font_size = 48
	settings.font_color = Color.RED
	settings.outline_size = 12
	settings.outline_color = Color.BLACK
	warning_label.label_settings = settings
	
	_update_visual(0.0, 1.0)

func _on_body_entered(_body: Node2D) -> void:
	pass 

func _on_body_exited(_body: Node2D) -> void:
	pass

func _process(delta: float) -> void:
	var danger_bodies = []
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			# Ignoriamo i frutti che stanno ancora salendo velocemente (appena sparati)
			# Ma se sono fermi o cadono sopra la linea, è pericolo
			if body.linear_velocity.y > -100.0: 
				danger_bodies.append(body)
	
	if danger_bodies.size() > 0:
		is_active = true
		timer += delta
		
		# Feedback visivo: intensità del rosso e velocità del glitch basata sul timer
		var progress = timer / LIMIT
		var alpha = 0.4 + progress * 0.6
		var shader_speed = 5.0 + progress * 15.0
		_update_visual(alpha, shader_speed)
		
		# Warning label effects
		warning_label.modulate.a = lerp(warning_label.modulate.a, 1.0, 0.1)
		warning_label.scale = Vector2(1.0, 1.0) * (2.0 + sin(Time.get_ticks_msec() * 0.02) * 0.2)
		
		if timer >= LIMIT:
			get_node("/root/GameManager").game_over()
	else:
		is_active = false
		timer = lerp(timer, 0.0, 0.1) # Cool down slowly
		_update_visual(0.2, 5.0)
		warning_label.modulate.a = lerp(warning_label.modulate.a, 0.0, 0.2)

func _update_visual(alpha: float, speed: float) -> void:
	var mat = visual.material as ShaderMaterial
	if mat:
		var color = Color(1.0, 0.0, 0.0, alpha)
		mat.set_shader_parameter("line_color", color)
		mat.set_shader_parameter("speed", speed)
