extends Node

# Preloaded Assets for Performance
const FRUIT_SCENE_PATH = "res://scenes/entities/fruit/fruit.tscn"
const MERGE_VFX_SCENE_PATH = "res://scenes/vfx/merge_particles.tscn"

var active_layout: Resource = preload("res://resources/layouts/slop_merge_spritesheet.tres")
# Fallback for older scripts using GameManager.SPRITESHEET
var SPRITESHEET: Texture2D:
	get: return active_layout.texture if active_layout else null

var FRUIT_SCENE = load(FRUIT_SCENE_PATH)
var MERGE_VFX_SCENE = load(MERGE_VFX_SCENE_PATH)

var slop_tokens: int:
	get: return SaveManager.slop_tokens
	set(v): SaveManager.slop_tokens = v

var current_skin: String:
	get: return SaveManager.current_skin
	set(v): SaveManager.current_skin = v

var unlocked_skins: Array:
	get: return SaveManager.unlocked_skins

var discovered_fruits: Array:
	get: return SaveManager.discovered_fruits

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
	print("[GameManager] Initialized.")

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
	if fruits_container:
		fruits_container.add_child(instance)
	else:
		get_tree().root.add_child(instance)
	
	instance.global_position = pos
	
	# VFX
	var vfx = MERGE_VFX_SCENE.instantiate()
	if fruits_container:
		fruits_container.add_child(vfx)
	else:
		get_tree().root.add_child(vfx)
	
	vfx.global_position = pos
	vfx.emitting = true
	if vfx.has_method("restart"):
		vfx.restart()
	
	# Discovery
	if not discovered_fruits.has(data.id):
		discovered_fruits.append(data.id)
		SaveManager.save_data()
	
	# Signal for other managers (Score, Juice, etc)
	EventBus.merge_occurred.emit(pos, data.id)
	
	# Basic Feedback (Managed here for now, or moved to JuiceManager later)
	EventBus.screen_shake_requested.emit(float(data.id) * 1.5)
	if has_node("/root/AudioManager"):
		AudioManager.play_tiered_sound(data.id)

func game_over() -> void:
	if is_game_over:
		return
	is_game_over = true
	
	# Tokens calculation (based on score from ScoreManager)
	if has_node("/root/ScoreManager"):
		var score = get_node("/root/ScoreManager").score
		slop_tokens += score / 10
	
	SaveManager.save_data()
	EventBus.game_over.emit()
	get_tree().paused = true

