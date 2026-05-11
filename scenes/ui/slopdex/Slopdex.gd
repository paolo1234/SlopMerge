extends Control

@onready var grid: GridContainer = %GridContainer
@onready var back_button: Button = $BackButton

func _ready() -> void:
	back_button.pressed.connect(_on_back_pressed)
	_populate_slopdex()

func _populate_slopdex() -> void:
	var gm = get_node("/root/GameManager")
	
	# Pulizia griglia
	for child in grid.get_children():
		child.queue_free()
	
	for fruit_data in gm.fruits_data:
		var slot = ColorRect.new()
		slot.custom_minimum_size = Vector2(200, 200)
		slot.color = Color(0.15, 0.15, 0.18, 1.0)
		grid.add_child(slot)
		
		var icon = TextureRect.new()
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.anchors_preset = Control.PRESET_FULL_RECT
		slot.add_child(icon)
		
		# Caricamento texture (usa lo stesso metodo di fruit.gd)
		var gm_texture = gm.SPRITESHEET
		
		var atlas = AtlasTexture.new()
		atlas.atlas = gm_texture
		
		var tex_size = gm_texture.get_size()
		var frame_size = tex_size.x / 16.0
		var fruit_index = (fruit_data.id - 1)
		var col = (fruit_index % 4) * 4
		var row = (fruit_index / 4) * 2
		atlas.region = Rect2(col * frame_size, row * frame_size, frame_size, frame_size)
		
		icon.texture = atlas
		
		if gm.discovered_fruits.has(fruit_data.id):
			icon.modulate = Color.WHITE
			var name_label = Label.new()
			name_label.text = fruit_data.fruit_name
			name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			name_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
			slot.add_child(name_label)
		else:
			icon.modulate = Color(0, 0, 0, 1.0) # Silhouette
			var quest_label = Label.new()
			quest_label.text = "???"
			quest_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			quest_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
			slot.add_child(quest_label)

func _on_back_pressed() -> void:
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
