extends PanelContainer

@onready var slot_container: HBoxContainer = %SlotContainer

func update_queue(queue: Array) -> void:
	# Pulizia slot precedenti se necessario (o riutilizzo)
	var slots = slot_container.get_children()
	
	for i in range(min(queue.size(), slots.size())):
		var fruit_data = queue[i]
		var slot = slots[i] as TextureRect
		
		if not fruit_data:
			slot.texture = null
			continue
			
		_apply_fruit_icon(slot, fruit_data)

func _apply_fruit_icon(target: TextureRect, data: Resource) -> void:
	var gm = GameManager
	var layout = gm.active_layout
	if not layout or not layout.texture:
		push_error("[NextQueue] SpriteSheetLayout or texture is null! Cannot apply icon.")
		return
	
	var atlas = AtlasTexture.new()
	atlas.atlas = layout.texture
	
	var sprite_key = layout.get_sprite_for_fruit(data.id)
	if sprite_key == "":
		sprite_key = data.sprite_key
		
	if sprite_key != "":
		atlas.region = layout.get_region_by_name(sprite_key)
	else:
		atlas.region = layout.get_region(data.id - 1, 0)
		
	target.texture = atlas
	
	print("[NextQueue] Applied icon for ", data.fruit_name, " region: ", atlas.region)
