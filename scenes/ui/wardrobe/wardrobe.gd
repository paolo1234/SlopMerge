extends Control

@onready var grid: GridContainer = %SkinGrid
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_populate_skins()

func _populate_skins() -> void:
	var gm = get_node("/root/GameManager")
	
	for child in grid.get_children():
		child.queue_free()
	
	for skin_name in gm.unlocked_skins:
		var card = VBoxContainer.new()
		card.custom_minimum_size = Vector2(300, 400)
		grid.add_child(card)
		
		var preview = ColorRect.new()
		preview.custom_minimum_size = Vector2(250, 250)
		preview.color = _get_skin_color(skin_name)
		card.add_child(preview)
		
		var name_label = Label.new()
		name_label.text = skin_name
		name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		card.add_child(name_label)
		
		var equip_btn = Button.new()
		equip_btn.text = "EQUIP"
		if gm.current_skin == skin_name:
			equip_btn.text = "EQUIPPED"
			equip_btn.disabled = true
		
		equip_btn.pressed.connect(_on_equip_pressed.bind(skin_name, equip_btn))
		card.add_child(equip_btn)

func _get_skin_color(skin: String) -> Color:
	match skin:
		"Gold": return Color(1.0, 0.84, 0)
		"Zombie": return Color(0.5, 0.8, 0.5)
		"Cyber": return Color(0, 1.0, 1.0)
		"Kawaii": return Color(1.0, 0.6, 0.8)
		"Edge": return Color(0.2, 0.2, 0.2)
		_: return Color(1, 1, 1)

func _on_equip_pressed(skin_name: String, btn: Button) -> void:
	var gm = get_node("/root/GameManager")
	gm.current_skin = skin_name
	gm.save_data()
	
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").play_sound("launch") # Reuse launch sound for feedback
	
	_populate_skins() # Refresh UI

func _on_back_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
