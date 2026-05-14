extends Node

## SaveManager: Dedicated source of truth for user progression and settings.
## Extracted from GameManager and ScoreManager for better separation of concerns.

const SAVE_PATH = "user://progression.cfg"

# State
var slop_tokens: int = 0
var high_score: int = 0
var current_skin: String = "default"
var unlocked_skins: Array = ["default"]
var discovered_fruits: Array = [1]

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_migrate_old_saves()
	load_data()

func save_data() -> void:
	var config = ConfigFile.new()
	# Load existing to preserve keys from different modules
	config.load(SAVE_PATH)
	
	config.set_value("progression", "slop_tokens", slop_tokens)
	config.set_value("progression", "high_score", high_score)
	config.set_value("progression", "current_skin", current_skin)
	config.set_value("progression", "unlocked_skins", unlocked_skins)
	config.set_value("progression", "discovered_fruits", discovered_fruits)
	
	var err = config.save(SAVE_PATH)
	if err != OK:
		push_error("[SaveManager] Failed to save data! Error: ", err)

func load_data() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var config = ConfigFile.new()
	var err = config.load(SAVE_PATH)
	if err == OK:
		slop_tokens = config.get_value("progression", "slop_tokens", 0)
		high_score = config.get_value("progression", "high_score", 0)
		current_skin = config.get_value("progression", "current_skin", "default")
		unlocked_skins = config.get_value("progression", "unlocked_skins", ["default"])
		discovered_fruits = config.get_value("progression", "discovered_fruits", [1])
		print("[SaveManager] Data loaded. HighScore: ", high_score)

func _migrate_old_saves() -> void:
	# 1. Migrate score.save (old format)
	var old_score_path = "user://score.save"
	if FileAccess.file_exists(old_score_path):
		var file = FileAccess.open(old_score_path, FileAccess.READ)
		if file:
			var old_score = file.get_var()
			file.close()
			if high_score < old_score:
				high_score = old_score
				print("[SaveManager] Migrated old score: ", old_score)
			DirAccess.remove_absolute(old_score_path)
	
	# Any other migrations can be added here...
	save_data()
