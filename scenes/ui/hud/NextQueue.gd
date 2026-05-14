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
	FruitVisuals.setup_texture_rect(target, data.id)
	FruitVisuals.apply_skin(target, GameManager.current_skin)
