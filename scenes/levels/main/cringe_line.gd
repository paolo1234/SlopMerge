extends Area2D

@onready var visual: ColorRect = $Visual

var timer: float = 0.0
var is_active: bool = false
const LIMIT: float = 3.0

var warning_label: Label

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Wait a bit to ensure UI is ready
	call_deferred("_setup_warning_label")
	
	_update_visual(0.0, 1.0)

func _setup_warning_label() -> void:
	# Add the warning label to the UI layer for better visibility
	var main_node = get_tree().root.get_node_or_null("Main")
	if not main_node: return
	
	var ui = main_node.get_node_or_null("UI")
	if ui:
		warning_label = Label.new()
		ui.add_child(warning_label)
		warning_label.text = "!!! CRINGE OVERLOAD !!!"
		warning_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		warning_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		warning_label.modulate.a = 0
		
		var settings = LabelSettings.new()
		settings.font_size = 72
		settings.font_color = Color.RED
		settings.outline_size = 18
		settings.outline_color = Color.BLACK
		settings.shadow_size = 20
		settings.shadow_color = Color(0.5, 0, 0, 0.7)
		warning_label.label_settings = settings
		
		# Position in screen space
		warning_label.set_anchors_preset(Control.PRESET_CENTER_TOP)
		warning_label.anchor_left = 0.5
		warning_label.anchor_right = 0.5
		warning_label.offset_left = -400
		warning_label.offset_right = 400
		warning_label.offset_top = 400
		warning_label.grow_horizontal = Control.GROW_DIRECTION_BOTH
		warning_label.scale = Vector2(1, 1)

func _on_body_entered(_body: Node2D) -> void:
	pass 

func _on_body_exited(_body: Node2D) -> void:
	pass

func _process(delta: float) -> void:
	var danger_bodies = []
	for body in get_overlapping_bodies():
		if body is RigidBody2D:
			if body.linear_velocity.y > -100.0: 
				danger_bodies.append(body)
	
	if danger_bodies.size() > 0:
		is_active = true
		timer += delta
		
		var progress = timer / LIMIT
		var alpha = 0.4 + progress * 0.6
		var shader_speed = 5.0 + progress * 15.0
		_update_visual(alpha, shader_speed)
		
		if warning_label:
			warning_label.visible = true
			warning_label.modulate.a = lerp(warning_label.modulate.a, 1.0, 0.1)
			var pulse = 1.0 + sin(Time.get_ticks_msec() * 0.02) * 0.15
			warning_label.scale = Vector2(pulse, pulse)
			warning_label.pivot_offset = warning_label.size / 2.0
		
		if timer >= LIMIT:
			get_node("/root/GameManager").game_over()
	else:
		is_active = false
		timer = lerp(timer, 0.0, 0.1)
		_update_visual(0.2, 5.0)
		if warning_label:
			warning_label.modulate.a = lerp(warning_label.modulate.a, 0.0, 0.2)
			if warning_label.modulate.a < 0.01:
				warning_label.visible = false

func _update_visual(alpha: float, speed: float) -> void:
	var mat = visual.material as ShaderMaterial
	if mat:
		var color = Color(1.0, 0.0, 0.0, alpha)
		mat.set_shader_parameter("line_color", color)
		mat.set_shader_parameter("speed", speed)
