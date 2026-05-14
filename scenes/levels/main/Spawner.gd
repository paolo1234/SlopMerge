extends Marker2D

signal queue_updated(new_queue: Array)

@export var fruit_scene: PackedScene
@export var current_fruit_data: Resource
@export var launch_force: float = 1200.0

var fruit_queue: Array[Resource] = []
var can_drop: bool = true
var is_aiming: bool = false
var is_laser_mode: bool = false
var aim_direction: Vector2 = Vector2.DOWN
var original_pos: Vector2
var preview_sprite: Sprite2D

func _process(delta: float) -> void:
	# Floating animation for preview
	if preview_sprite and preview_sprite.visible:
		var time = Time.get_ticks_msec() / 1000.0
		preview_sprite.position.y = sin(time * 4.0) * 10.0
		preview_sprite.rotation = sin(time * 2.0) * 0.1
	
	# Fade in preview when ready
	if can_drop and preview_sprite and not preview_sprite.visible:
		preview_sprite.visible = true
		preview_sprite.modulate.a = 0.0
		
	if preview_sprite and preview_sprite.visible and preview_sprite.modulate.a < 1.0:
		preview_sprite.modulate.a = move_toward(preview_sprite.modulate.a, 1.0, delta * 5.0)

func _ready() -> void:
	original_pos = position
	
	# Crea lo sprite di preview dinamicamente
	preview_sprite = Sprite2D.new()
	preview_sprite.name = "PreviewSprite"
	add_child(preview_sprite)
	
	# Fix: Se non settati dall'inspector, usa quelli del GameManager (precaricati)
	if not fruit_scene:
		fruit_scene = GameManager.FRUIT_SCENE
	
	# Inizializza la coda con abbastanza frutti
	_prepare_next_fruit()

func _get_random_starter_fruit() -> Resource:
	var starter_pool = GameManager.fruits_data.slice(0, 3)
	if starter_pool.is_empty(): return null
	return starter_pool.pick_random()

func _prepare_next_fruit() -> void:
	# Garantisce di avere almeno 4 frutti totali nel sistema
	while fruit_queue.size() < 4:
		fruit_queue.append(_get_random_starter_fruit())
	
	# Preleva il prossimo frutto per la mano (preview)
	current_fruit_data = fruit_queue.pop_front()
	
	# Assicura di avere sempre 3 frutti pronti per la HUD dopo il pop
	while fruit_queue.size() < 3:
		fruit_queue.append(_get_random_starter_fruit())
		
	# Invia alla UI esattamente i 3 frutti che verranno DOPO quello in mano
	queue_updated.emit(fruit_queue.slice(0, 3))
	
	_update_preview_visual()

func _update_preview_visual() -> void:
	if not preview_sprite or not current_fruit_data: return
	
	var layout = GameManager.active_layout
	if not layout: return
	
	preview_sprite.texture = layout.texture
	preview_sprite.region_enabled = true
	
	var sprite_key = layout.get_sprite_for_fruit(current_fruit_data.id)
	if sprite_key == "":
		sprite_key = current_fruit_data.sprite_key
		
	if sprite_key != "":
		preview_sprite.region_rect = layout.get_region_by_name(sprite_key)
	else:
		preview_sprite.region_rect = layout.get_region(current_fruit_data.id - 1, 0)
		
	# Calcola la scala per farlo corrispondere alla dimensione reale
	var target_size = current_fruit_data.radius * 2.0
	var actual_w = preview_sprite.region_rect.size.x
	if actual_w > 0:
		var s = target_size / actual_w
		preview_sprite.scale = Vector2(s, s)
	
	preview_sprite.visible = true
	preview_sprite.modulate.a = 1.0

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
	# Convert viewport position to world position for accurate aiming
	var world_target = get_viewport().get_canvas_transform().affine_inverse() * target_pos
	aim_direction = (world_target - global_position).normalized()
	
	# Force aiming UPWARDS (negative Y)
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
	if not fruit_scene:
		push_error("[Spawner] Critical: fruit_scene is NULL!")
		return
	if not current_fruit_data:
		push_error("[Spawner] Critical: current_fruit_data is NULL! (GameManager.fruits_data might be empty)")
		return
		
	can_drop = false
	var fruit_instance = fruit_scene.instantiate() as RigidBody2D
	fruit_instance.data = current_fruit_data
	fruit_instance.global_position = global_position
	
	print("[Spawner] Spawning fruit: ", current_fruit_data.fruit_name, " at ", global_position)
	
	if GameManager.fruits_container:
		GameManager.fruits_container.add_child(fruit_instance)
	else:
		push_warning("[Spawner] GameManager.fruits_container is null, adding to parent.")
		get_parent().add_child(fruit_instance)
	
	fruit_instance.apply_central_impulse(aim_direction * launch_force)
	
	# Hide preview while reloading
	if preview_sprite:
		preview_sprite.visible = false
	
	_prepare_next_fruit()
	
	if has_node("/root/AudioManager"):
		AudioManager.play_sound("launch")
		
	if is_inside_tree():
		await get_tree().create_timer(0.5).timeout
	can_drop = true
