# 🏗 Scene Architect

> Skill specializzata nella progettazione di Scene Tree Godot 4.

## Responsabilità
- Progettare gerarchie di Scene Tree ottimali
- Applicare il Component Pattern (nodi figli con singola responsabilità)
- Definire la comunicazione tra nodi (signals up, calls down)
- Scegliere il tipo di nodo corretto per ogni ruolo
- Progettare scene riutilizzabili e instanziabili

## Regole
- Ogni scena deve avere un diagramma ASCII PRIMA dell'implementazione
- I nodi devono avere nomi descrittivi in PascalCase
- Nessun nodo deve avere più di una responsabilità
- Le scene complesse devono essere spezzate in sub-scene riutilizzabili
- Usare `@export` per configurazione dall'Inspector

## Node Type Reference Rapido

| Scopo | 2D | 3D |
|---|---|---|
| Personaggio | `CharacterBody2D` | `CharacterBody3D` |
| Nemico statico | `StaticBody2D` | `StaticBody3D` |
| Proiettile | `Area2D` | `Area3D` |
| UI | `Control` / `CanvasLayer` | `Control` / `CanvasLayer` |
| Trigger zone | `Area2D` | `Area3D` |
| Sprite | `Sprite2D` / `AnimatedSprite2D` | `MeshInstance3D` |
| Collisione | `CollisionShape2D` | `CollisionShape3D` |
| Camera | `Camera2D` | `Camera3D` |
| Particelle | `GPUParticles2D` | `GPUParticles3D` |
