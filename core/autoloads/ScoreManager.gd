extends Node

var score: int = 0
var high_score: int = 0
var combo_multiplier: int = 1
var combo_timer: float = 0.0
const COMBO_RESET_TIME: float = 3.0

const SAVE_PATH = "user://progression.cfg"

func _ready() -> void:
	_migrate_old_save()
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
		save_high_score()
	
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
	var config = ConfigFile.new()
	config.load(SAVE_PATH)
	config.set_value("progression", "high_score", high_score)
	config.save(SAVE_PATH)

func load_high_score() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var config = ConfigFile.new()
		var err = config.load(SAVE_PATH)
		if err == OK:
			high_score = config.get_value("progression", "high_score", 0)

func _migrate_old_save() -> void:
	var old_path = "user://score.save"
	if FileAccess.file_exists(old_path):
		var file = FileAccess.open(old_path, FileAccess.READ)
		if file:
			var old_score = file.get_var()
			file.close()
			
			# Se il nuovo record è 0 o inferiore al vecchio, migra
			if high_score < old_score:
				high_score = old_score
				save_high_score()
				print("[ScoreManager] Migrated old score: ", old_score)
			
			# Rimuovi il vecchio file per evitare loop
			DirAccess.remove_absolute(old_path)
