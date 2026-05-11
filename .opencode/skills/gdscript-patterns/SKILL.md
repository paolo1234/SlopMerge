---
name: gdscript-patterns
description: "Pattern GDScript avanzati per Godot 4"
---

# 📜 GDScript Patterns

> Skill specializzata nei pattern GDScript avanzati per Godot 4.

## Responsabilità
- Scrivere GDScript idiomatico con type hints obbligatori
- Applicare pattern architetturali Godot (Component, Observer, State)
- Ottimizzare il codice per performance mobile
- Gestire correttamente il ciclo di vita dei nodi
- Implementare Custom Resources per dati configurabili

## Pattern Obbligatori

### Type Hints
```gdscript
var speed: float = 300.0
var health: int = 100
var direction: Vector2 = Vector2.ZERO
@export var stats: CharacterStats
@onready var sprite: Sprite2D = $Sprite2D
func take_damage(amount: int) -> void:
    pass
func get_speed() -> float:
    return speed
```

### Signal Declaration
```gdscript
signal health_changed(new_value: int)
signal died
signal state_changed(old_state: String, new_state: String)
```

### @onready e @export
```gdscript
@export var move_speed: float = 200.0
@export_range(0, 100) var spawn_chance: int = 50
@export var enemy_scene: PackedScene
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
```

### Lifecycle Methods Order
```gdscript
# Ordine consigliato dei metodi in uno script:
# 1. Signals
# 2. @export variables
# 3. @onready variables
# 4. Private variables
# 5. _ready()
# 6. _process() / _physics_process()
# 7. _unhandled_input()
# 8. Public methods
# 9. Private methods
# 10. Signal callbacks (_on_*)
```