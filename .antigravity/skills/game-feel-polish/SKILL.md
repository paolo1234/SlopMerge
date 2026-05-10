# ✨ Game Feel & Polish

> Skill specializzata nel miglioramento del "game feel" — la sensazione di gioco.

## Responsabilità
- Aggiungere feedback visivi e sonori a ogni azione del giocatore
- Implementare juice effects (screen shake, flash, particles, scale bounce)
- Migliorare la responsività e soddisfazione del gameplay
- Suggerire effetti di polish per ogni feature implementata
- Implementare haptic feedback su mobile

## Tecniche di Game Feel

### Screen Shake
```gdscript
func shake_camera(intensity: float = 5.0, duration: float = 0.2) -> void:
    var tween: Tween = create_tween()
    var original_offset: Vector2 = camera.offset
    for i: int in range(10):
        var offset: Vector2 = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))
        tween.tween_property(camera, "offset", original_offset + offset, duration / 10.0)
    tween.tween_property(camera, "offset", original_offset, duration / 10.0)
```

### Hit Flash
```gdscript
func flash_white(sprite: Sprite2D, duration: float = 0.1) -> void:
    sprite.material.set_shader_parameter("flash_amount", 1.0)
    await get_tree().create_timer(duration).timeout
    sprite.material.set_shader_parameter("flash_amount", 0.0)
```

### Scale Bounce (Squash & Stretch)
```gdscript
func bounce_scale(node: Node2D, squash: Vector2 = Vector2(1.2, 0.8)) -> void:
    var tween: Tween = create_tween()
    tween.tween_property(node, "scale", squash, 0.05)
    tween.tween_property(node, "scale", Vector2.ONE, 0.15).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
```

### Haptic Feedback (Mobile)
```gdscript
func haptic_light() -> void:
    Input.vibrate_handheld(50)

func haptic_heavy() -> void:
    Input.vibrate_handheld(100)
```

## Checklist per Feature
Per ogni feature, chiediti:
- [ ] C'è un feedback visivo per l'azione? (particle, flash, scale)
- [ ] C'è un feedback sonoro? (sfx, jingle)
- [ ] C'è un feedback tattile? (vibrazione su mobile)
- [ ] L'animazione usa easing? (mai lineare per movimenti di gioco)
- [ ] C'è una breve pausa ("hitstop") per azioni impattanti?
