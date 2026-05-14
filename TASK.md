# Task: Slop Merge

## Fase 1: Godot Base & Prototipo ✅
- [x] Setup struttura cartelle base in `res://`
- [x] Creazione risorsa Custom `FruitData`
- [x] Prototipo scena `Fruit` (RigidBody2D)
- [x] Implementazione Spawner (Mira direzionale, Lancio dal basso)

## Fase 2: Juiciness & UI ✅
- [x] Implementazione Shader "Squishy Physics"
- [x] Integrazione Spritesheet dinamica
- [x] Creazione UI Brainrot Meter
- [x] Implementazione effetti particellari Merge

## Fase 3: Audio & Polish ✅
- [x] Implementazione `AudioManager` (Singleton)
- [x] Integrazione suoni Merge e Launch (Logica)
- [x] Trajectory Line a punti (Dotted)
- [x] Debug Visualization (Collider rossi)

## Fase 4: Avanzate & Meta ✅
- [x] Logica Game Over (Cringe Line)
- [x] Schermata Game Over UI e Restart
- [x] Power-up "Laser Beam" (Meccanica core)
- [x] Sistema di Salvataggio High Score

## Fase 5: Menu & Rifinitura 🛠️
- [x] Creazione Scena Main Menu
- [/] Transizioni tra scene (Fade in/out)
- [x] Effetto visivo Laser (Linea luminosa)
- [x] Sistema di Combo (Moltiplicatore punteggio)
- [x] Sistema economico base (Gettoni Slop)
- [x] Sistema Gacha (Macchinetta skin)

# Task: Fase 6 (Personalizzazione) 🛠️
- [/] Applicazione visuale Skin sui frutti
- [/] Pokedex (Galleria scoperte)
- [/] Wardrobe (Selezione skin)

## Fase 7: Polish & Audio 🛠️
- [x] Menù di Pausa con settings volume
- [x] Full Project Testing & Slopdex Fix
## Fase 8: Sviluppo & Deploy Mobile ✅
- [x] Fase 8: Mobile Deployment & In-Game Update
    - [x] Implementare UpdateManager (Check version.json su GitHub)
    - [x] Download APK asincrono con progress bar
    - [x] Integrazione installazione nativa Android
    - [x] Fix rendering frutti su Android (Case-sensitivity & VRAM)
- [x] Fase 10: Hardening & Visual Polish
    - [x] Fix SlopEditor persistence (Migrate state & UI refresh)
    - [x] Implement Fruit Hand Preview (Floating sprite at spawner)
    - [x] Disable debug collider visuals for clean gameplay
    - [x] Fix SpriteSheetLayout resource path issues
    - [x] Revert Spawner movement & recoil (Back to fixed shooter)
    - [x] Fix HUD Overlap & Queue Duplication (v1.8.4)
- [ ] Fase 11: Metagame & Audio
    - [ ] Integrazione SFX (AudioManager)
    - [ ] Screen Shake globale
    - [ ] Feature "Frullatore del Caos" (Meter 100%)
