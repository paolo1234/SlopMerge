extends RigidBody2D
class_name Fruit

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

func _apply_data() -> void:
	if GameManager.SPRITESHEET:
		sprite.texture = GameManager.SPRITESHEET
	
	sprite.region_enabled = true
	
	# Calcoliamo la dimensione del frame in base alla dimensione reale della texture
	var tex_size = sprite.texture.get_size()
	var frame_size = tex_size.x / 16.0
	
	var fruit_index = (data.id - 1)
	var col = (fruit_index % 4) * 4 # Ogni frutto ha 4 frame
	var row = (fruit_index / 4) * 2 # Ogni frutto occupa 2 righe (idle animation)
	
	sprite.region_rect = Rect2(col * frame_size, row * frame_size, frame_size, frame_size)
	
	mass = data.mass
	
	var shape = CircleShape2D.new()
	shape.radius = data.radius
	collision_shape.shape = shape
	
	var merge_shape = CircleShape2D.new()
	merge_shape.radius = data.radius * 1.1
	merge_collision.shape = merge_shape
	
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
	if body is Fruit and body != self:
		if body.data.id == self.data.id:
			# Chiediamo al GameManager di gestire la fusione
			GameManager.request_merge(self, body)
