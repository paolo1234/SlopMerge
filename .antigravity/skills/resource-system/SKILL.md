# 📦 Resource System

> Skill specializzata nella progettazione di Custom Resources (.tres) per Godot 4.

## Responsabilità
- Progettare Custom Resources per dati configurabili (stats, wave config, item data)
- Separare i dati dal codice (data-driven design)
- Permettere ai designer di modificare valori dall'Inspector senza toccare codice
- Gestire il caricamento lazy di risorse pesanti

## Pattern Standard

### Custom Resource Definition
```gdscript
# resources/CharacterStats.gd
extends Resource
class_name CharacterStats

@export var display_name: String = ""
@export var max_health: int = 100
@export var speed: float = 300.0
@export var damage: int = 10
@export var attack_cooldown: float = 0.5
@export var sprite: Texture2D
```

### Utilizzo nello Script
```gdscript
# Il componente carica i dati dalla risorsa
@export var stats: CharacterStats

func _ready() -> void:
    health = stats.max_health
    move_speed = stats.speed
```

### Resource Arrays (Wave System, Loot Table, etc.)
```gdscript
# resources/WaveConfig.gd
extends Resource
class_name WaveConfig

@export var wave_number: int = 1
@export var enemy_count: int = 5
@export var spawn_interval: float = 1.0
@export var enemy_types: Array[PackedScene] = []
```

## Regole
- **Mai hardcodare** dati negli script — sempre in .tres
- Ogni risorsa ha il suo script `.gd` con `class_name`
- Le risorse vanno in `res://resources/` organizzate per tipo
- Usare `@export_range`, `@export_enum` per vincolare i valori
- Per risorse pesanti (texture grandi), usare `ResourceLoader.load()` lazy
