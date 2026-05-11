extends Label

func _ready() -> void:
	pass

func setup(txt: String, color: Color = Color.WHITE) -> void:
	text = txt
	modulate = color
	
	# Animazione
	var tween = create_tween().set_parallel(true)
	
	# Sposta verso l'alto
	tween.tween_property(self, "position", position + Vector2(randf_range(-100, 100), -250), 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# Fade out
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_delay(0.5)
	
	# Scale Up & Down
	scale = Vector2.ZERO
	tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# Distruggi al termine
	tween.chain().tween_callback(queue_free)
	
	print("Floating Text setup at: ", position, " with text: ", txt)
	# Rotazione casuale per il feeling "brainrot"
	rotation_degrees = randf_range(-15, 15)
	pivot_offset = size / 2.0
