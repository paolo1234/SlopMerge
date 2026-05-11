---
name: error-optimizer
description: "Gestione robusta degli errori in GDScript per Godot 4"
---

# 🛡 Error Optimizer (GDScript)

> Skill specializzata nella gestione robusta degli errori in GDScript per Godot 4.

## Responsabilità
- Implementare gestione errori con guard clauses
- Usare `push_error()` e `push_warning()` in modo strutturato
- Validare input e precondizioni con `assert()`
- Gestire gracefully errori di caricamento risorse
- Evitare crash su mobile (null reference, divisione per zero)

## Pattern

### Guard Clauses
```gdscript
func apply_damage(target: Node, amount: int) -> void:
    if target == null:
        push_error("apply_damage: target is null")
        return
    if not target.has_method("take_damage"):
        push_warning("apply_damage: target has no take_damage method")
        return
    target.take_damage(amount)
```

### Safe Resource Loading
```gdscript
func load_scene_safe(path: String) -> PackedScene:
    if not ResourceLoader.exists(path):
        push_error("Scene not found: " + path)
        return null
    var scene: PackedScene = load(path) as PackedScene
    if scene == null:
        push_error("Failed to load scene: " + path)
    return scene
```

### Assert per Debug
```gdscript
func _ready() -> void:
    assert(stats != null, "CharacterStats resource not assigned!")
    assert(max_health > 0, "max_health must be positive")
```

## Regole
- Mai ignorare condizioni di errore — sempre gestirle
- `push_error()` per errori che indicano un bug nel codice
- `push_warning()` per situazioni inattese ma gestibili
- `assert()` solo per precondizioni in debug (rimossi in release)
- Mai `print()` per errori — usare il sistema di logging Godot