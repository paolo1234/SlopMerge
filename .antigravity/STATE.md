# Stato Attuale del Progetto: Slop Merge

**Versione Corrente**: v1.8.7 (Bug Fix Release)
**Stato**: Fase 10 - Polish & Release (Completata)

## Milestone Recenti 🚀
- [x] **Fix Race Condition**: Risolto il bug "Restart + Pause" segnalato dall'utente.
- [x] **Unified UI Utility**: Tutte le animazioni bottoni centralizzate in `UIUtils`.
- [x] **Robust Audio Pooling**: Sistema a 12 canali per evitare tagli sonori durante i merge rapidi.
- [x] **Refactor Clean Architecture**: Creazione di `FruitVisuals` e `SaveManager`.
- [x] **Zero-Duplication Logic**: Rimozione di 150+ righe di codice ridondante.
- [x] **Bug Hunting v1.8.4**: Risolti glitch di transizione e ordine di spawn.
- [x] **Spawner Polish**: Ottimizzato layout per evitare collisioni con la HUD.
- [x] Menù di Pausa: Implementazione completa con blur shader, settings volume e navigazione.

## Task Completati ✅
- [x] Setup struttura cartelle base in `res://`
- [x] Creazione risorsa Custom `FruitData` per i parametri dei frutti
- [x] Prototipo scena `Fruit` (RigidBody2D + Shader Squishy + Region Sprite)
- [x] Implementazione Spawner (Mira direzionale, Lancio dal basso)
- [x] Fix Rendering Android: Risolto bug case-sensitivity (Fruit.tscn) e ripristinata compressione VRAM (mode=2).
- [x] Update System: Corretto branch URL (master) e attivato sistema di download diretto.)
- [x] Logica di Game Over (Cringe Line) e High Score persistente
- [x] Fase 8: Mobile Deployment & In-Game Update
- [x] **SlopEditor & Zero-Step Pipeline**: Creato tool web-based per la gestione dinamica degli asset.
    - [x] Mapping dinamico Tier -> Sprite (senza limiti di numero).
    - [x] Gestione collisioni (Circle/Rect) e offset visivi nell'editor.
    - [x] Supporto "Visual Scale" per ridimensionare sprite indipendentemente dalla fisica.
    - [x] Integrazione nativa in Godot via `SpriteSheetLayout`.
- [x] **Gestione Spritesheet**: Implementato `SpriteSheetLayout` (sistema a risorse centralizzato).

## Task Attivi (In corso) 🛠️
- [x] **Game-Core Sync & Revamp**: Estrazione miglioramenti generici in `game-core`.
- [ ] **Frullatore del Caos**: Implementazione abilità speciale attiva al 100% del Meter.
- [ ] **Power-up Magnete**: Raggio traente per riposizionare frutti (Ads rewarded).
- [ ] **Power-up Slow Motion**: Rallentamento temporaneo del tempo.
- [ ] **Daily Quests base**: Sistema di missioni giornaliere per guadagnare gettoni.

## Debiti Tecnici ⚠️
- AudioManager non ha ancora i file audio reali (usa placeholder/null).
- Segnali inutilizzati in `EventBus.gd` rilevati durante il testing.

## 📂 Archivio Debiti Tecnici Risolti
- [x] **Performance Mobile**: Sostituite chiamate `load()` con `preload()` in GameManager e Fruit.
- [x] **Standard Naming**: Refactoring di tutti gli script principali in `PascalCase`.
- [x] **Debug Overhead**: Debug drawing (`_draw`) in Fruit reso condizionale a `OS.is_debug_build()`.
- [x] **VRAM Texture Android**: Corretto import dello spritesheet da Lossless (`compress/mode=0`) a VRAM Compressed (`compress/mode=2`).
- [x] **Null Safety Texture**: Aggiunta protezione null su `sprite.texture` in Fruit.gd, NextQueue.gd e Slopdex.gd.
- [x] **FileAccess → ResourceLoader**: Sostituito `FileAccess.file_exists()` con `ResourceLoader.exists()` in AudioManager.gd.
- [x] **Android Permissions**: Abilitati `WRITE_EXTERNAL_STORAGE` e `REQUEST_INSTALL_PACKAGES` per il sistema di update.

## 🛠 In Corso
- [x] **Full Project Validation**: Eseguito testing completo di gameplay, UI e metagame.
- [ ] **Nuova Feature**: Implementazione "Frullatore del Caos" (Meter 100%).