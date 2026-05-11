extends Marker2D

@export var fruit_scene: PackedScene
@export var current_fruit_data: Resource
@export var launch_force: float = 1200.0

var can_drop: bool = true
var is_aiming: bool = false
var is_laser_mode: bool = false
var aim_direction: Vector2 = Vector2.DOWN
var original_pos: Vector2

func _ready() -> void:
	original_pos = position
	
	# Fix: Se non settati dall'inspector, carica i default
	if not fruit_scene:
		fruit_scene = load("res://scenes/entities/fruit/fruit.tscn")
	
	if not current_fruit_data:
		_prepare_next_fruit()

func _prepare_next_fruit() -> void:
	# Sceglie a caso tra i primi 3 frutti (Starter)
	var starter_pool = GameManager.fruits_data.slice(0, 3)
	if starter_pool.is_empty(): return
	current_fruit_data = starter_pool.pick_random()

func _unhandled_input(event: InputEvent) -> void:
	if not can_drop:
		return
		
	if get_viewport().is_input_handled():
		return
		
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if event.pressed:
			is_aiming = true
			_update_aim(event.position)
		elif event.is_released() and is_aiming:
			is_aiming = false
			if is_laser_mode:
				fire_laser()
			else:
				launch_fruit()
			queue_redraw()
			
	elif (event is InputEventScreenDrag or event is InputEventMouseMotion) and is_aiming:
		_update_aim(event.position)
		
	elif event is InputEventKey:
		if event.pressed and event.keycode == KEY_L:
			is_laser_mode = !is_laser_mode

func _update_aim(target_pos: Vector2) -> void:
	aim_direction = (target_pos - global_position).normalized()
	
	if aim_direction.y > -0.2:
		aim_direction.y = -0.2
		aim_direction = aim_direction.normalized()
		
	queue_redraw()

func _draw() -> void:
	if not is_aiming:
		return
		
	var dot_count = 12
	var dot_spacing = 45.0
	var dot_radius = 5.0
	var color = Color(1, 0, 0, 0.8) if is_laser_mode else Color(1, 1, 1, 0.6)
	
	for i in range(1, dot_count):
		var pos = aim_direction * i * dot_spacing
		draw_circle(pos, dot_radius, color)

func fire_laser() -> void:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, global_position + aim_direction * 2000.0)
	var result = space_state.intersect_ray(query)
	
	if result:
		var hit_node = result.collider
		if hit_node is RigidBody2D:
			hit_node.queue_free()
			
			var line = Line2D.new()
			add_child(line)
			line.add_point(Vector2.ZERO)
			line.add_point(aim_direction * global_position.distance_to(result.position))
			line.width = 15.0
			line.default_color = Color(1, 0, 0, 1)
			
			var tween = create_tween()
			tween.tween_property(line, "width", 0.0, 0.2)
			tween.tween_callback(line.queue_free)
			
			if has_node("/root/AudioManager"):
				AudioManager.play_sound("laser")
	
	is_laser_mode = false

func launch_fruit() -> void:
	if not fruit_scene or not current_fruit_data:
		return
		
	can_drop = false
	var fruit_instance = fruit_scene.instantiate() as RigidBody2D
	fruit_instance.data = current_fruit_data
	fruit_instance.global_position = global_position
	
	if GameManager.fruits_container:
		GameManager.fruits_container.add_child(fruit_instance)
	else:
		get_parent().add_child(fruit_instance)
	
	fruit_instance.apply_central_impulse(aim_direction * launch_force)
	
	_prepare_next_fruit()
	
	if has_node("/root/AudioManager"):
		AudioManager.play_sound("launch")
	
	# Recoil effect (Game Feel Tip)
	var recoil_tween = create_tween()
	recoil_tween.tween_property(self, "position", original_pos + Vector2(0, 30), 0.05).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	recoil_tween.tween_property(self, "position", original_pos, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	can_drop = true
