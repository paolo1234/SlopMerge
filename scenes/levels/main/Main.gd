extends Node2D

@onready var fruits_container: Node2D = $FruitsContainer
@onready var camera: Camera2D = $Camera2D
@onready var floating_container: Control = $UI/FloatingContainer

const FLOATING_TEXT_SCENE = preload("res://scenes/ui/hud/floating_text.tscn")
const GAME_OVER_SCENE = preload("res://scenes/ui/game_over/game_over.tscn")

var shake_intensity: float = 0.0

func _ready() -> void:
	# Registra il container nel GameManager per ottimizzare le ricerche
	GameManager.fruits_container = fruits_container
	GameManager.score = 0
	GameManager.is_game_over = false
	
	# Connect to EventBus signals
	EventBus.merge_occurred.connect(_on_merge_occurred)
	EventBus.chain_event.connect(_on_chain_event)
	EventBus.game_over.connect(_on_game_over)
	
	# Connetti la coda dei frutti
	var spawner = $Spawner
	var next_queue = $UI/HUD/%NextQueue
	spawner.queue_updated.connect(next_queue.update_queue)
	
	# Inizializza visualmente la coda
	next_queue.update_queue(spawner.fruit_queue)

func _process(delta: float) -> void:
	if shake_intensity > 0:
		camera.offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)) * shake_intensity
		shake_intensity = lerp(shake_intensity, 0.0, delta * 10.0)
	else:
		camera.offset = Vector2.ZERO

func shake(intensity: float, _duration: float = 0.5) -> void:
	shake_intensity = intensity

func _on_game_over() -> void:
	var instance = GAME_OVER_SCENE.instantiate()
	$UI.add_child(instance) # Add to UI layer

func _on_merge_occurred(_pos: Vector2, power: int) -> void:
	shake(5.0 + (power * 2.0))

func _on_chain_event(pos: Vector2, count: int, bonus: float) -> void:
	if count > 1:
		var text_inst = FLOATING_TEXT_SCENE.instantiate()
		floating_container.add_child(text_inst)
		
		# Converti posizione mondo in posizione UI
		var screen_pos = get_viewport().get_canvas_transform() * pos
		text_inst.position = screen_pos
		
		var color = Color.WHITE
		var msg = "X%d COMBO!" % count
		
		if count >= 3:
			color = Color(1, 0.8, 0, 1) # Oro
			msg = "SUPER COMBO! X%d" % count
		if count >= 5:
			color = Color(1, 0, 0.5, 1) # Magenta/Neon
			msg = "BRAINROT X%d!!!" % count
			
		text_inst.setup(msg, color)
