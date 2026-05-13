extends Node

# Preloaded Assets for Performance
const FRUIT_SCENE = preload("res://scenes/entities/fruit/fruit.tscn")
const MERGE_VFX_SCENE = preload("res://scenes/vfx/merge_particles.tscn")
const SPRITESHEET = preload("res://assets/sprites/slop_merge_spritesheet.png")

var score: int = 0
var high_score: int = 0
var slop_tokens: int = 0
var current_skin: String = "default"
var unlocked_skins: Array = ["default"]
var discovered_fruits: Array = [1]
var combo_multiplier: int = 1
var combo_timer: float = 0.0
const COMBO_RESET_TIME: float = 2.0

var fruits_data: Array[Resource] = [
	preload("res://resources/fruits/01_pisello.tres"),
	preload("res://resources/fruits/02_limone.tres"),
	preload("res://resources/fruits/03_kiwi.tres"),
	preload("res://resources/fruits/04_arancia.tres"),
	preload("res://resources/fruits/05_uva.tres"),
	preload("res://resources/fruits/06_fragola.tres"),
	preload("res://resources/fruits/07_melone.tres"),
	preload("res://resources/fruits/08_ananas.tres"),
	preload("res://resources/fruits/09_cocco.tres"),
	preload("res://resources/fruits/10_anguria.tres"),
	preload("res://resources/fruits/11_zucca.tres")
]
var fruits_container: Node2D
var main_scene: Node2D
var is_game_over: bool = false

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_data()
	
	print("[GameManager] Initialized with ", fruits_data.size(), " fruits.")
	for i in range(fruits_data.size()):
		if fruits_data[i] == null:
			push_error("[GameManager] Critical: Fruit at index " + str(i) + " is NULL!")
		else:
			print("[GameManager] Loaded fruit: ", fruits_data[i].fruit_name)
	
	if SPRITESHEET == null:
		push_error("[GameManager] Critical: SPRITESHEET is NULL on load!")
	else:
		print("[GameManager] Spritesheet loaded, size: ", SPRITESHEET.get_size())

func _process(delta: float) -> void:
	if combo_multiplier > 1:
		combo_timer -= delta
		if combo_timer <= 0:
			combo_multiplier = 1
			EventBus.combo_changed.emit(combo_multiplier)

func get_next_tier_data(current_id: int) -> Resource:
	if current_id < fruits_data.size():
		return fruits_data[current_id]
	return null

func request_merge(fruit_a: Node2D, fruit_b: Node2D) -> void:
	if fruit_a.data.id != fruit_b.data.id:
		return
	
	if fruit_a.is_queued_for_deletion() or fruit_b.is_queued_for_deletion():
		return
		
	var next_data = get_next_tier_data(fruit_a.data.id)
	if not next_data:
		return
		
	var spawn_pos = (fruit_a.global_position + fruit_b.global_position) / 2.0
	
	fruit_a.queue_free()
	fruit_b.queue_free()
	
	call_deferred("_spawn_merged_fruit", next_data, spawn_pos)

func _spawn_merged_fruit(data: Resource, pos: Vector2) -> void:
	var instance = FRUIT_SCENE.instantiate() as RigidBody2D
	instance.data = data
	instance.global_position = pos
	
	if fruits_container:
		fruits_container.add_child(instance)
	else:
		get_tree().root.add_child(instance)
	
	# VFX
	var vfx = MERGE_VFX_SCENE.instantiate()
	get_tree().root.add_child(vfx)
	vfx.global_position = pos
	vfx.emitting = true
	
	# Discovery
	if not discovered_fruits.has(data.id):
		discovered_fruits.append(data.id)
		save_data()
	
	EventBus.merge_occurred.emit(pos, data.id)
	
	# Combo & Chain logic
	combo_multiplier += 1
	combo_timer = COMBO_RESET_TIME
	EventBus.combo_changed.emit(combo_multiplier)
	
	var bonus_refill = float(data.id * 2.0) + (combo_multiplier * 1.5)
	EventBus.chain_event.emit(pos, combo_multiplier, bonus_refill)
	
	score += (data.id * 10) * combo_multiplier
	EventBus.score_changed.emit(score)
	
	if has_node("/root/AudioManager"):
		AudioManager.play_sound("merge")

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	
	if score > high_score:
		high_score = score
		save_data()
	
	var earned_tokens = score / 10
	slop_tokens += earned_tokens
	save_data()
	
	EventBus.game_over.emit()
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
