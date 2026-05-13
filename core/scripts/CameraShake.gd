extends Camera2D

@export var decay: float = 0.8  # Quanta velocità perde lo shake al secondo
@export var max_offset: Vector2 = Vector2(50, 25)  # Offset massimo in pixel
@export var max_roll: float = 0.1  # Rotazione massima in radianti

var trauma: float = 0.0  # Livello attuale di trauma (0 to 1)
var trauma_power: int = 2  # Esponente per rendere lo shake più morbido

func _ready() -> void:
	EventBus.screen_shake_requested.connect(add_trauma)

func _process(delta: float) -> void:
	if trauma > 0:
		trauma = max(trauma - decay * delta, 0)
		_shake()

func add_trauma(amount: float) -> void:
	# amount dovrebbe essere normalizzato o scalato
	# es. se passiamo tier * 1.5, limitiamolo
	var normalized_amount = clamp(amount / 20.0, 0.0, 1.0)
	trauma = min(trauma + normalized_amount, 1.0)

func _shake() -> void:
	var amount = pow(trauma, trauma_power)
	rotation = max_roll * amount * randf_range(-1, 1)
	offset.x = max_offset.x * amount * randf_range(-1, 1)
	offset.y = max_offset.y * amount * randf_range(-1, 1)
