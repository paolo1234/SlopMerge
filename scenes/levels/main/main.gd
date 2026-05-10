extends Node2D

@onready var fruits_container: Node2D = $FruitsContainer
@onready var camera: Camera2D = $Camera2D

var shake_intensity: float = 0.0

func _ready() -> void:
	# Registra il container nel GameManager per ottimizzare le ricerche
	var gm = get_node("/root/GameManager")
	gm.fruits_container = fruits_container
	gm.score = 0 # Reset score per la nuova partita
	
	gm.merge_occurred.connect(_on_merge_occurred)

func _process(delta: float) -> void:
	if shake_intensity > 0:
		camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		shake_intensity = lerp(shake_intensity, 0.0, delta * 10.0)
	else:
		camera.offset = Vector2.ZERO

func _on_merge_occurred(_pos: Vector2, power: int) -> void:
	shake_intensity = 5.0 + (power * 2.0)
