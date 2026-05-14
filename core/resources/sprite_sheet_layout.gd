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
@export var regions: Dictionary = {} # Name -> Rect2

func get_region(index: int, sub_index: int = 0) -> Rect2:
	if not texture:
		return Rect2()
		
	var tex_size = texture.get_size()
	
	match type:
		LayoutType.SIMPLE_GRID:
			var cell_w = tex_size.x / columns
			var cell_h = tex_size.y / rows
			var col = index % columns
			var row = index / columns
			return Rect2(col * cell_w, row * cell_h, cell_w, cell_h)
			
		LayoutType.NESTED_GRID:
			var block_w = tex_size.x / columns
			var block_h = tex_size.y / rows
			var b_col = index % columns
			var b_row = index / columns
			
			var frame_w = block_w / sub_columns
			var frame_h = block_h / sub_rows
			var f_col = sub_index % sub_columns
			var f_row = sub_index / sub_columns
			
			return Rect2(
				(b_col * block_w) + (f_col * frame_w),
				(b_row * block_h) + (f_row * frame_h),
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
