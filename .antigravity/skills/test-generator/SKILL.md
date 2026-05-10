# 🧪 Test Generator (GUT — Godot Unit Testing)

> Skill specializzata nella creazione di test automatizzati per Godot 4 con GUT.

## Responsabilità
- Scrivere unit test per la logica di business (non per la UI)
- Testare Custom Resources e componenti isolati
- Verificare FSM transitions e signal emissions
- Validare input handling e calcoli matematici

## Framework: GUT (Godot Unit Testing)

### Struttura Test
```gdscript
# test/unit/test_health_component.gd
extends GutTest

var _health_component: HealthComponent

func before_each() -> void:
    _health_component = HealthComponent.new()
    _health_component.max_health = 100
    add_child(_health_component)
    _health_component._ready()

func after_each() -> void:
    _health_component.queue_free()

func test_should_start_at_max_health() -> void:
    assert_eq(_health_component.current_health, 100)

func test_should_reduce_health_when_damaged() -> void:
    _health_component.take_damage(30)
    assert_eq(_health_component.current_health, 70)

func test_should_emit_died_when_health_zero() -> void:
    watch_signals(_health_component)
    _health_component.take_damage(100)
    assert_signal_emitted(_health_component, "died")

func test_should_not_go_below_zero() -> void:
    _health_component.take_damage(999)
    assert_eq(_health_component.current_health, 0)
```

## Naming Convention
- File: `test_[cosa_stai_testando].gd`
- Funzione: `test_should_[expected]_when_[condition]`
- Cartella: `res://test/unit/` e `res://test/integration/`

## Regole
- Testare solo la logica di business, non i nodi di scena
- Ogni test deve essere indipendente (setup/teardown con `before_each`/`after_each`)
- Usare `watch_signals()` per verificare emissioni di segnali
- Non testare `_process()` direttamente — testa i metodi che chiama
