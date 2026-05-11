---
name: fsm-designer
description: "Progettazione di Finite State Machines per Godot 4"
---

# 🔄 FSM Designer

> Skill specializzata nella progettazione di Finite State Machines per Godot 4.

## Responsabilità
- Progettare FSM corrette con nodo `StateMachine` + figli `State`
- Garantire transizioni pulite (enter/exit)
- Implementare FSM per player, nemici, UI e game flow
- Evitare FSM monolitiche — dividere in sotto-macchine se necessario

## Architettura Standard

```
CharacterBody2D
├── StateMachine
│   ├── IdleState
│   ├── RunState
│   ├── JumpState
│   └── AttackState
├── HealthComponent
├── Sprite2D
└── CollisionShape2D
```

## Regole
- Ogni stato è un nodo figlio della `StateMachine`
- Ogni stato conosce SOLO il proprio comportamento
- Transizione tramite `state_machine.transition_to("NomeStato")`
- Ogni stato implementa: `enter()`, `exit()`, `update(delta)`, `physics_update(delta)`
- Lo stato emette `state_finished` quando ha completato il suo compito
- La StateMachine gestisce la transizione, mai lo stato stesso

## Base State Template
```gdscript
# State.gd — classe base per tutti gli stati
extends Node
class_name State

var state_machine: StateMachine

func enter() -> void:
    pass

func exit() -> void:
    pass

func update(delta: float) -> void:
    pass

func physics_update(delta: float) -> void:
    pass
```