extends Control

@onready var token_label: Label = %TokenLabel
@onready var result_label: Label = %ResultLabel
@onready var pull_button: Button = $VBoxContainer/PullButton
@onready var back_button: Button = $VBoxContainer/BackButton

var gm

func _ready() -> void:
	gm = get_node("/root/GameManager")
	_update_ui()
	
	pull_button.pressed.connect(_on_pull_pressed)
	back_button.pressed.connect(_on_back_pressed)

func _update_ui() -> void:
	token_label.text = "Tokens: " + str(gm.slop_tokens)
	pull_button.disabled = gm.slop_tokens < 100

func _on_pull_pressed() -> void:
	if gm.slop_tokens >= 100:
		gm.slop_tokens -= 100
		_do_gacha_pull()
		_update_ui()
		gm.save_data()

func _do_gacha_pull() -> void:
	var possible_skins = ["Gold", "Zombie", "Cyber", "Kawaii", "Edge"]
	var skin = possible_skins[randi() % possible_skins.size()]
	
	result_label.text = "YOU GOT: " + skin + "!"
	result_label.modulate = Color.WHITE
	
	if not gm.unlocked_skins.has(skin):
		gm.unlocked_skins.append(skin)
	
	# Animation
	var tween = create_tween()
	result_label.scale = Vector2(0.5, 0.5)
	tween.tween_property(result_label, "scale", Vector2(1.5, 1.5), 0.5).set_trans(Tween.TRANS_ELASTIC)
	tween.parallel().tween_property(result_label, "modulate", Color(1, 0.8, 0), 0.5)

func _on_back_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
