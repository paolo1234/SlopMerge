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
		
	if GameManager.SPRITESHEET:
		sprite.texture = GameManager.SPRITESHEET
	
	if not sprite.texture:
		push_error("Fruit: SPRITESHEET is null! Falling back to icon.svg for visibility test.")
		sprite.texture = load("res://icon.svg")
		if not sprite.texture:
			return
	
	var tex_size = sprite.texture.get_size()
	# Guard: su alcuni driver mobile get_size() può essere 0 se chiamato troppo presto
	if tex_size.x <= 0:
		push_warning("Fruit: Texture size is 0! Using fallback size 2048.")
		tex_size = Vector2(2048, 2048)
		
	sprite.region_enabled = true
	
	# Ogni frutto occupa un blocco 512x512 (griglia 4x4)
	var fruit_sheet_size = tex_size.x / 4.0
	var frame_size = fruit_sheet_size / 4.0
	
	var fruit_index = (data.id - 1)
	var col = (fruit_index % 4)
	var row = (fruit_index / 4)
	
	# Prendiamo il primo frame (0,0) del blocco del frutto
	sprite.region_rect = Rect2(col * fruit_sheet_size, row * fruit_sheet_size, frame_size, frame_size)
	
	# Autoscale lo sprite per corrispondere al raggio fisico
	var target_size = data.radius * 2.0
	var scale_factor = target_size / frame_size
	
	# Guard: scale INF o NaN fa sparire lo sprite
	if is_inf(scale_factor) or is_nan(scale_factor) or scale_factor <= 0:
		push_error("Fruit: Invalid scale_factor: " + str(scale_factor) + ". Setting to 1.0")
		scale_factor = 1.0
		
	sprite.scale = Vector2(scale_factor, scale_factor)
	
	mass = data.mass
	
	var shape = CircleShape2D.new()
	shape.radius = data.radius
	collision_shape.shape = shape
	
	var merge_shape = CircleShape2D.new()
	merge_shape.radius = data.radius * 1.1
	merge_collision.shape = merge_shape
	
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
