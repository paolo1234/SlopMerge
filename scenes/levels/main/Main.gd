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
	print("[Main] FruitsContainer registered: ", fruits_container)
	if has_node("/root/ScoreManager"):
		ScoreManager.reset_score()
	GameManager.is_game_over = false
	
	# Connect to EventBus signals
	EventBus.chain_event.connect(_on_chain_event)
	EventBus.game_over.connect(_on_game_over)
	
	# Responsive Layout
	_adjust_layout()
	get_viewport().size_changed.connect(_adjust_layout)
	
	# Connetti la coda dei frutti
	var spawner = $Spawner
	var next_queue = $UI/HUD/%NextQueue
	spawner.queue_updated.connect(next_queue.update_queue)
	
	# Inizializza visualmente la coda
	var initial_display: Array = [spawner.current_fruit_data]
	initial_display.append_array(spawner.fruit_queue)
	next_queue.update_queue(initial_display)

func _on_game_over() -> void:
	var instance = GAME_OVER_SCENE.instantiate()
	$UI.add_child(instance) # Add to UI layer

func _on_chain_event(pos: Vector2, count: int, _bonus: float) -> void:
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

func _adjust_layout() -> void:
	var size = get_viewport_rect().size
	var center_x = size.x / 2.0
	
	print("[Main] Adjusting layout for size: ", size)
	
	# 1. Boundaries
	if has_node("Boundaries"):
		var boundaries = $Boundaries
		if boundaries.has_node("LeftWall"):
			boundaries.get_node("LeftWall").global_position.x = 0
		if boundaries.has_node("RightWall"):
			boundaries.get_node("RightWall").global_position.x = size.x
		if boundaries.has_node("Ceiling"):
			var ceiling = boundaries.get_node("Ceiling")
			ceiling.global_position.x = center_x
			if ceiling is CollisionShape2D and ceiling.shape is RectangleShape2D:
				ceiling.shape = ceiling.shape.duplicate() # Make unique
				ceiling.shape.size.x = size.x
		if boundaries.has_node("Floor"):
			var floor_node = boundaries.get_node("Floor")
			floor_node.global_position.x = center_x
			if floor_node is CollisionShape2D and floor_node.shape is RectangleShape2D:
				floor_node.shape = floor_node.shape.duplicate() # Make unique
				floor_node.shape.size.x = size.x

	# 2. Spawner
	if has_node("Spawner"):
		$Spawner.global_position.x = center_x
		$Spawner.global_position.y = size.y - 300 # Position at the bottom
		
	# 3. CringeLine
	if has_node("CringeLine"):
		var cl = $CringeLine
		cl.global_position.x = center_x
		var visual = cl.get_node_or_null("Visual")
		if visual:
			visual.set_anchors_preset(Control.PRESET_CENTER)
			visual.size.x = size.x
			visual.position.x = -center_x
