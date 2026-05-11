extends Node2D

func _ready() -> void:
	var sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/slop_merge_spritesheet.png")
	sprite.centered = false
	# Scale down to fit screenshot (540x960)
	var scale = 540.0 / 2048.0
	sprite.scale = Vector2(scale, scale)
	add_child(sprite)
