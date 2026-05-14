extends RigidBody2D

# Preloaded Assets
const SQUISHY_SHADER = preload("res://assets/shaders/squishy_fruit.gdshader")

@export var data: Resource

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var merge_area: Area2D = $MergeArea
@onready var merge_collision: CollisionShape2D = $MergeArea/CollisionShape2D

var is_dropping: bool = true

func _ready() -> void:
	merge_area.body_entered.connect(_on_merge_area_body_entered)
	if data:
		_apply_data()
	
	# Inizializza lo shader
	if sprite.material == null:
		sprite.material = ShaderMaterial.new()
		sprite.material.shader = SQUISHY_SHADER
		
	# Su Android (Compatibility) gli shader che modificano VERTEX a volte causano problemi di visibilità
	if OS.get_name() == "Android":
		print("[Fruit] Disabling squishy shader on Android for compatibility test.")
		sprite.material = null
	else:
		print("[Fruit] Shader material assigned.")

func _apply_data() -> void:
	if not data:
		push_error("Fruit: data is NULL in _apply_data!")
		return
		
	var layout = GameManager.active_layout
	if not layout:
		push_error("Fruit: active_layout is null!")
		return
		
	sprite.texture = layout.texture
	sprite.region_enabled = true
	
	# Priority: 1. Mapping from Editor, 2. Manual key in .tres, 3. Fallback index
	var sprite_key = layout.get_sprite_for_fruit(data.id)
	if sprite_key == "":
		sprite_key = data.sprite_key
		
	if sprite_key != "":
		sprite.region_rect = layout.get_region_by_name(sprite_key)
	else:
		sprite.region_rect = layout.get_region(data.id - 1, 0)
		
	# Update collision data based on the resolved key
	var col_data = {}
	var custom_scale = 1.0
	if sprite_key != "":
		col_data = layout.get_collision_data(sprite_key)
		custom_scale = layout.get_custom_scale(sprite_key)
	
	# Autoscale lo sprite per corrispondere al raggio fisico
	var target_size = data.radius * 2.0 * custom_scale
	var actual_sprite_w = sprite.region_rect.size.x
	
	if actual_sprite_w <= 0:
		actual_sprite_w = layout.get_frame_size().x
		
	var scale_factor = target_size / actual_sprite_w
	
	# Guard: scale INF o NaN fa sparire lo sprite
	if is_inf(scale_factor) or is_nan(scale_factor) or scale_factor <= 0:
		push_error("Fruit: Invalid scale_factor for " + data.fruit_name + ". Setting to 1.0")
		scale_factor = 1.0
		
	sprite.scale = Vector2(scale_factor, scale_factor)
	
	mass = data.mass
	
	# Physics / Collision
	var shape: Shape2D
	
	if col_data.get("type") == "circle":
		shape = CircleShape2D.new()
		var raw_rad = col_data.get("radius", 0.0)
		if raw_rad > 0:
			shape.radius = raw_rad * scale_factor
		else:
			shape.radius = data.radius
		collision_shape.position = Vector2(col_data.get("ox", 0), col_data.get("oy", 0)) * scale_factor
	elif col_data.get("type") == "rect":
		shape = RectangleShape2D.new()
		var rw = col_data.get("w", 64) * scale_factor
		var rh = col_data.get("h", 64) * scale_factor
		shape.size = Vector2(rw, rh)
		collision_shape.position = Vector2(col_data.get("ox", 0), col_data.get("oy", 0)) * scale_factor
	else:
		# Fallback to default radius
		shape = CircleShape2D.new()
		shape.radius = data.radius
		collision_shape.position = Vector2.ZERO
		
	collision_shape.shape = shape
	
	# Merge Area (slightly larger than collision)
	var merge_shape = CircleShape2D.new()
	if shape is CircleShape2D:
		merge_shape.radius = shape.radius * 1.1
	else:
		merge_shape.radius = data.radius * 1.1
		
	merge_collision.shape = merge_shape
	merge_collision.position = collision_shape.position
	
	print("[Fruit] Initialized: ", data.fruit_name, " ID: ", data.id, " Pos: ", global_position, " Scale: ", sprite.scale)
	
	_apply_skin()

func _apply_skin() -> void:
	var skin = GameManager.current_skin
	
	match skin:
		"Gold":
			sprite.modulate = Color(1.2, 1.1, 0.2, 1.0) # Oro brillante
		"Zombie":
			sprite.modulate = Color(0.5, 0.8, 0.5, 1.0) # Verde marcio
		"Cyber":
			sprite.modulate = Color(0.2, 1.0, 1.2, 1.0) # Ciano neon
		"Kawaii":
			sprite.modulate = Color(1.2, 0.6, 0.8, 1.0) # Rosa pastello
		"Edge":
			sprite.modulate = Color(0.3, 0.3, 0.3, 1.0) # Oscuro
		_:
			sprite.modulate = Color.WHITE # Default

func _process(_delta: float) -> void:
	# Aggiorna lo shader in base alla velocità lineare
	if sprite.material:
		var vel_strength = linear_velocity.length() / 500.0
		sprite.material.set_shader_parameter("strength", clamp(vel_strength * 0.1, 0.0, 0.2))
	
	if OS.is_debug_build():
		queue_redraw()

func _draw() -> void:
	# Debug visualization
	if OS.is_debug_build() and data:
		draw_arc(Vector2.ZERO, data.radius, 0, TAU, 32, Color(1, 0, 0, 0.5), 2.0)

func _on_merge_area_body_entered(body: Node2D) -> void:
	if body.has_method("_on_merge_area_body_entered") and body != self:
		if body.data.id == self.data.id:
			# Chiediamo al GameManager di gestire la fusione
			GameManager.request_merge(self, body)
