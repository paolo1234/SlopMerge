extends Area2D

var timer: float = 0.0
var is_active: bool = false
const LIMIT: float = 3.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(_body: Node2D) -> void:
	is_active = true

func _on_body_exited(_body: Node2D) -> void:
	if get_overlapping_bodies().size() == 0:
		is_active = false
		timer = 0.0

func _process(delta: float) -> void:
	if is_active:
		timer += delta
		if timer >= LIMIT:
			get_node("/root/GameManager").game_over()
