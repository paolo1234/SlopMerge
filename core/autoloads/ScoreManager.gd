extends Node

var score: int = 0
var high_score: int = 0
var combo_multiplier: int = 1
var combo_timer: float = 0.0
const COMBO_RESET_TIME: float = 3.0

const SAVE_PATH = "user://score.save"

func _ready() -> void:
	load_high_score()
	EventBus.merge_occurred.connect(_on_merge_occurred)
	EventBus.game_over.connect(save_high_score)

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

func save_high_score() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(high_score)
		file.close()

func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			high_score = file.get_var()
			file.close()
