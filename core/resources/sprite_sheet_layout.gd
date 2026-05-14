extends Resource
class_name SpriteSheetLayout

enum LayoutType {
	SIMPLE_GRID,    # Just a grid of items
	NESTED_GRID,    # Blocks, each with its own internal grid (current system)
	EXPLICIT        # Manual mapping (future proofing)
}

@export var texture: Texture2D
@export var type: LayoutType = LayoutType.NESTED_GRID

@export_group("Grid Settings")
@export var columns: int = 4
@export var rows: int = 4

@export_group("Nested Settings")
@export var sub_columns: int = 4
@export var sub_rows: int = 4

@export_group("Explicit Settings")
@export var regions: Dictionary = {} # Name -> { rect, pivot, collision }
@export var fruit_map: Dictionary = {} # TierID -> SpriteName
@export var anims: Dictionary = {}   # Name -> { fps, loop, frames: [name, ...] }

func get_sprite_for_fruit(tier_id: int) -> String:
	return fruit_map.get(str(tier_id), "")

func get_region_by_name(region_name: String) -> Rect2:
	var data = regions.get(region_name)
	if data is Dictionary:
		return data.get("rect", Rect2())
	if data is Rect2:
		return data
	return Rect2()

func get_collision_data(region_name: String) -> Dictionary:
	var data = regions.get(region_name)
	if data is Dictionary:
		return data.get("collision", { "type": "none" })
	return { "type": "none" }

func get_custom_scale(region_name: String) -> float:
	var data = regions.get(region_name)
	if data is Dictionary:
		return data.get("scale", 1.0)
	return 1.0

func get_anim_data(anim_name: String) -> Dictionary:
	return anims.get(anim_name, {})

func get_region(index: Variant, sub_index: int = 0) -> Rect2:
	# If index is a String, use dictionary lookup
	if index is String:
		return get_region_by_name(index)
		
	if not texture:
		return Rect2()
		
	var tex_size = texture.get_size()
	
	match type:
		LayoutType.SIMPLE_GRID:
			var cell_w: float = tex_size.x / float(columns)
			var cell_h: float = tex_size.y / float(rows)
			var col: int = index % columns
			var row: int = floori(float(index) / columns)
			return Rect2(col * cell_w, row * cell_h, cell_w, cell_h)
			
		LayoutType.NESTED_GRID:
			var block_w: float = tex_size.x / float(columns)
			var block_h: float = tex_size.y / float(rows)
			var b_col: int = index % columns
			var b_row: int = floori(float(index) / columns)
			
			var frame_w: float = block_w / float(sub_columns)
			var frame_h: float = block_h / float(sub_rows)
			var f_col: int = sub_index % sub_columns
			var f_row: int = floori(float(sub_index) / sub_columns)
			
			return Rect2(
				(float(b_col) * block_w) + (float(f_col) * frame_w),
				(float(b_row) * block_h) + (float(f_row) * frame_h),
				frame_w,
				frame_h
			)
			
		LayoutType.EXPLICIT:
			# If we pass a string as index (needs casting or overloading, but GDScript is dynamic)
			# We'll assume index is used as a key if we want to expand this.
			return Rect2()
			
	return Rect2()

func get_block_size() -> Vector2:
	if not texture: return Vector2.ZERO
	return texture.get_size() / Vector2(columns, rows)

func get_frame_size() -> Vector2:
	if not texture: return Vector2.ZERO
	var b_size = get_block_size()
	if type == LayoutType.NESTED_GRID:
		return b_size / Vector2(sub_columns, sub_rows)
	return b_size
