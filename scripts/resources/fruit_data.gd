extends Resource
class_name FruitData

@export var id: int = 1
@export var fruit_name: String = "Pisello Triste"
@export var sprite_key: String = "" # Name from SlopEditor
@export var idle_anim_key: String = "" # Name from SlopEditor
@export var mass: float = 1.0
@export var radius: float = 30.0
@export var sprite_texture: Texture2D
@export var next_evolution: Resource

@export_group("Spritesheet Mapping")
@export var sheet_col: int = 0
@export var sheet_row: int = 0
@export var frame_col: int = 0
@export var frame_row: int = 0
