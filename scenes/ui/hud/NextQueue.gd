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
	target.texture_filter = Control.TEXTURE_FILTER_PARENT_NODE
	
	var tex_size = tex.get_size()
	if tex_size.x <= 0:
		push_warning("[NextQueue] Texture size is 0, using fallback 2048.")
		tex_size = Vector2(2048, 2048)
	
	var atlas = AtlasTexture.new()
	atlas.atlas = tex
	
	var block_size = tex_size.x / 4.0 # 512
	var frame_size = block_size / 4.0 # 128
	
	var b_col = data.sheet_col
	var b_row = data.sheet_row
	
	# Se sono a 0 (default), usiamo l'ID come fallback per il blocco
	# NOTA: sheet_row = 3 era un errore nei .tres, forziamo il ricalcolo se fuori griglia 4x4
	if (b_col == 0 and b_row == 0) or b_row > 2:
		var fruit_index = (data.id - 1)
		b_col = (fruit_index % 4)
		b_row = (fruit_index / 4)
	
	var f_col = data.frame_col
	var f_row = data.frame_row
	
	var base_rect_x = (b_col * block_size) + (f_col * frame_size)
	var base_rect_y = (b_row * block_size) + (f_row * frame_size)
	atlas.region = Rect2(base_rect_x, base_rect_y, frame_size, frame_size)
	target.texture = atlas
	target.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	target.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	
	print("[NextQueue] Applied icon for ", data.fruit_name, " region: ", atlas.region)
