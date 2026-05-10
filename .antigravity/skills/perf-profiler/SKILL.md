# ⚡ Performance Profiler (Godot 4 Mobile)

> Skill specializzata nell'analisi e ottimizzazione delle performance per Godot 4, con focus mobile.

## Responsabilità
- Identificare bottleneck di performance tramite Godot Profiler
- Ottimizzare draw calls, physics e GDScript
- Garantire 60 FPS stabili su dispositivi mid-range
- Monitorare l'uso di memoria e texture budget
- Ridurre consumo batteria

## Strumenti

### Godot Profiler
```gdscript
# Monitorare performance in tempo reale
var fps: float = Performance.get_monitor(Performance.TIME_FPS)
var draw_calls: float = Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
var objects: float = Performance.get_monitor(Performance.RENDER_TOTAL_OBJECTS_IN_FRAME)
var physics_time: float = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)
```

## Checklist Performance Mobile
- [ ] Nessuna allocazione in `_process()` / `_physics_process()`
- [ ] `@onready` per tutti i node lookups
- [ ] Tween riutilizzati, non creati ogni frame
- [ ] Texture ≤ 2048×2048 con compressione ETC2/ASTC
- [ ] Sprite atlanti per ridurre draw calls
- [ ] `queue_free()` su nodi non più necessari
- [ ] Physics tick ≤ 60 Hz
- [ ] Nessun shader complesso su mobile
- [ ] `ResourceLoader.load()` lazy per risorse pesanti
- [ ] Object pooling per proiettili/nemici frequenti
