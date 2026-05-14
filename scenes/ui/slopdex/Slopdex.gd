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
		slot.add_child(icon)
		icon.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
		
		var layout = gm.active_layout
		if not layout or not layout.texture:
			push_error("[Slopdex] SpriteSheetLayout or texture is null! Skipping icon.")
			continue
			
		var atlas = AtlasTexture.new()
		atlas.atlas = layout.texture

		var sprite_key = layout.get_sprite_for_fruit(fruit_data.id)
		if sprite_key == "":
			sprite_key = fruit_data.sprite_key
			
		if sprite_key != "":
			atlas.region = layout.get_region_by_name(sprite_key)
		else:
			atlas.region = layout.get_region(fruit_data.id - 1, 0)
			
		icon.texture = atlas
		
		print("[Slopdex] Created slot for ", fruit_data.fruit_name, " region: ", atlas.region)
		
		if gm.discovered_fruits.has(fruit_data.id):
			icon.modulate = Color.WHITE
			var name_label = Label.new()
			name_label.text = fruit_data.fruit_name
			name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			name_label.autowrap_mode = TextServer.AUTOWRAP_WORD
			name_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
			slot.add_child(name_label)
		else:
			icon.modulate = Color(0.1, 0.1, 0.1, 0.8) # Silhouette grigia scura semi-trasparente
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
