extends Node

var score: int = 0
var high_score: int = 0
var slop_tokens: int = 0
var current_skin: String = "default"
var unlocked_skins: Array = ["default"]
var discovered_fruits: Array = [1] # ID 1 (Pisello) è sempre scoperto
var combo_multiplier: int = 1
var combo_timer: float = 0.0
const COMBO_RESET_TIME: float = 2.0

signal score_changed(new_score)
signal combo_changed(new_combo)
signal on_game_over

var fruits_data: Array = []

func _ready() -> void:
	load_data()
	# ... rest of ready ...

func _process(delta: float) -> void:
	if combo_multiplier > 1:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_multiplier = 1
			combo_changed.emit(combo_multiplier)
	# Carichiamo i dati dei frutti (in futuro automatizzato)
	fruits_data.append(load("res://resources/fruits/01_pisello.tres"))
	fruits_data.append(load("res://resources/fruits/02_limone.tres"))
	fruits_data.append(load("res://resources/fruits/03_kiwi.tres"))

func get_next_tier_data(current_id: int) -> Resource:
	if current_id < fruits_data.size():
		return fruits_data[current_id] # L'id è 1-based, quindi index current_id è il tier successivo
	return null

func request_merge(fruit_a: Node2D, fruit_b: Node2D) -> void:
	if fruit_a.data.id != fruit_b.data.id:
		return
	
	if fruit_a.is_queued_for_deletion() or fruit_b.is_queued_for_deletion():
		return
		
	var next_data = get_next_tier_data(fruit_a.data.id)
	if not next_data:
		# Massimo livello raggiunto o errore
		return
		
	var spawn_pos = (fruit_a.global_position + fruit_b.global_position) / 2.0
	
	# Rimuovi i vecchi
	fruit_a.queue_free()
	fruit_b.queue_free()
	
	# Istanzia il nuovo
	call_deferred("_spawn_merged_fruit", next_data, spawn_pos)

func _spawn_merged_fruit(data: Resource, pos: Vector2) -> void:
	var fruit_scene = load("res://scenes/entities/fruit/fruit.tscn")
	var instance = fruit_scene.instantiate() as RigidBody2D
	instance.data = data
	instance.global_position = pos
	
	# Lo aggiungiamo al contenitore (dovremmo avere un riferimento o usare il root)
	get_tree().root.find_child("FruitsContainer", true, false).add_child(instance)
	
	# Istanzia VFX
	var vfx_scene = load("res://scenes/vfx/merge_particles.tscn")
	var vfx = vfx_scene.instantiate()
	get_tree().root.add_child(vfx)
	vfx.global_position = pos
	vfx.emitting = true
	
	# Pokedex discovery
	if not discovered_fruits.has(data.id):
		discovered_fruits.append(data.id)
		save_data()
	
	# Gestione Combo
	combo_multiplier += 1
	combo_timer = COMBO_RESET_TIME
	combo_changed.emit(combo_multiplier)
	
	score += (data.id * 10) * combo_multiplier
	score_changed.emit(score)
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("merge")
		
	print("Merged! New Score: ", score)

func game_over() -> void:
	if score > high_score:
		high_score = score
		save_data()
	
	# Calcola i gettoni (es. 10% del punteggio)
	var earned_tokens = score / 10
	slop_tokens += earned_tokens
	save_data()
	
	on_game_over.emit()
	print("GAME OVER! Final Score: ", score)
	
	var game_over_scene = load("res://scenes/ui/game_over/game_over.tscn")
	var instance = game_over_scene.instantiate()
	get_tree().root.add_child(instance)
	
	get_tree().paused = true

func save_data() -> void:
	var config = ConfigFile.new()
	config.set_value("progression", "high_score", high_score)
	config.set_value("progression", "slop_tokens", slop_tokens)
	config.set_value("progression", "current_skin", current_skin)
	config.set_value("progression", "unlocked_skins", unlocked_skins)
	config.set_value("progression", "discovered_fruits", discovered_fruits)
	config.save("user://savegame.cfg")

func load_data() -> void:
	var config = ConfigFile.new()
	var err = config.load("user://savegame.cfg")
	if err == OK:
		high_score = config.get_value("progression", "high_score", 0)
		slop_tokens = config.get_value("progression", "slop_tokens", 0)
		current_skin = config.get_value("progression", "current_skin", "default")
		unlocked_skins = config.get_value("progression", "unlocked_skins", ["default"])
		discovered_fruits = config.get_value("progression", "discovered_fruits", [1])
