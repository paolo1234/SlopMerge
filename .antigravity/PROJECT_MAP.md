# PROJECT MAP: Slop Merge

## Obiettivo del Gioco
Creare un puzzle game "Inverse Shooter" (Shoot & Bounce) che trattenga i giocatori attraverso un gameplay fisico iper-stimolante, meccaniche "salva-vita" ad-driven, un "Brainrot Meter" (combo) e un solido metagame.

## Scene Principali
- **Main**: `res://scenes/levels/main/main.tscn` (Loop di gioco, Spawner, CringeLine).
- **Fruit**: `res://scenes/entities/fruit/fruit.tscn` (Entità fisica con shader squishy).
- **GameOver**: `res://scenes/ui/game_over/game_over.tscn` (Schermata fine partita).
- **HUD**: `res://scenes/ui/hud/hud.tscn` (Score, Combo Display).
- **Floating Text**: `res://scenes/ui/hud/floating_text.tscn` (Feedback arcade animato).
- **Brainrot Meter**: `res://scenes/ui/brainrot_meter/brainrot_meter.tscn` (Barra verticale energia).

## Autoloads (Singletons)
- **GameManager**: `res://core/autoloads/GameManager.gd` (Score, Highscore, Logica Merge, Skins).
- **AudioManager**: `res://core/autoloads/AudioManager.gd` (Pool di AudioStreamPlayer).
- **TransitionManager**: `res://core/autoloads/TransitionManager.tscn` (Gestione Fade tra scene).
- **UpdateManager**: `res://core/autoloads/UpdateManager.gd` (Controllo aggiornamenti in-game via HTTP).

## Architettura File System (res://)
```text
res://
├── assets/
│   ├── audio/ (sfx, music)
│   ├── shaders/ (squishy_fruit.gdshader)
│   └── sprites/ (slop_merge_spritesheet.png)
├── core/
│   ├── autoloads/ (GameManager, AudioManager, TransitionManager)
│   └── resources/ (sprite_sheet_layout.gd)
├── resources/
│   ├── fruits/ (File .tres per ogni tier di frutto)
│   └── layouts/ (default_spritesheet.tres)
├── scenes/
│   ├── entities/ (fruit.tscn)
│   ├── levels/ (main.tscn)
│   ├── ui/ (hud.tscn, game_over.tscn, slopdex.tscn, gacha.tscn, wardrobe.tscn, brainrot_meter.tscn)
│   └── vfx/ (merge_particles.tscn)
├── scripts/
│   └── resources/ (fruit_data.gd)
└── .antigravity/ (documentazione)
```