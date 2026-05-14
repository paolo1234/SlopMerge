extends Node

var score: int = 0
var high_score: int:
	get: return SaveManager.high_score
	set(v): SaveManager.high_score = v
var combo_multiplier: int = 1
var combo_timer: float = 0.0
const COMBO_RESET_TIME: float = 3.0

const SAVE_PATH = "user://progression.cfg"

func _ready() -> void:
	EventBus.merge_occurred.connect(_on_merge_occurred)
	EventBus.game_over.connect(SaveManager.save_data)

func _process(delta: float) -> void:
	if combo_timer > 0:
		combo_timer -= delta
		if combo_timer <= 0:
			reset_combo()

func _on_merge_occurred(_pos: Vector2, tier: int) -> void:
	combo_multiplier += 1
	combo_timer = COMBO_RESET_TIME
	
	var points = (tier * 10) * combo_multiplier
	score += points
	
	if score > high_score:
		high_score = score
		SaveManager.save_data()
	
	EventBus.score_changed.emit(score)
	EventBus.combo_changed.emit(combo_multiplier)

func reset_combo() -> void:
	combo_multiplier = 1
	EventBus.combo_changed.emit(combo_multiplier)

func reset_score() -> void:
	score = 0
	combo_multiplier = 1
	EventBus.score_changed.emit(score)
	EventBus.combo_changed.emit(combo_multiplier)

