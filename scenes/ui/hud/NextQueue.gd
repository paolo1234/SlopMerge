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
	var tex = gm.SPRITESHEET
	
	if not tex:
		push_error("[NextQueue] SPRITESHEET is null! Cannot apply icon.")
		return
	
	var tex_size = tex.get_size()
	if tex_size.x <= 0:
		push_warning("[NextQueue] Texture size is 0, using fallback 2048.")
		tex_size = Vector2(2048, 2048)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = tex
	
	var fruit_sheet_size = tex_size.x / 4.0 # 512
	var frame_size = fruit_sheet_size / 4.0 # 128
	
	var fruit_index = (data.id - 1)
	var col = (fruit_index % 4)
	var row = (fruit_index / 4)
	
	atlas.region = Rect2(col * fruit_sheet_size, row * fruit_sheet_size, frame_size, frame_size)
	target.texture = atlas
	
	print("[NextQueue] Applied icon for ", data.fruit_name, " region: ", atlas.region)
