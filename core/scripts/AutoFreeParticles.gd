extends CPUParticles2D

func _ready() -> void:
	emitting = true
	# Si autodistrugge dopo la fine della vita delle particelle + un piccolo buffer
	get_tree().create_timer(lifetime + 0.1).timeout.connect(queue_free)
