# Stato Attuale del Progetto: Slop Merge

- [x] Premium GameOver: Refinement grafico (blur, tween) e fix stabilità (is_game_over flag).
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
    - [x] Implementare UpdateManager (Check version.json su GitHub)
    - [x] Download APK asincrono con progress bar
    - [x] Integrazione installazione nativa Android
    - [x] Fix rendering frutti su Android (Case-sensitivity & VRAM)
- [ ] Fase 9: Metagame & Audio
    - [ ] Integrazione SFX (AudioManager)
    - [ ] Screen Shake globale
    - [ ] Feature "Frullatore del Caos"rmance (Caching & Direct Refs)
- [x] Fix raggi di collisione nei file .tres (allineamento con sprite)
- [x] Implementazione tutti i tier di frutta (1-11) con risorse dedicate
- [x] Sistema di Reazioni a Catena: Floating Text e Combo Multipliers
- [x] Upgrade Risoluzione: Porting a 1080x1920 (Full HD Mobile) e adattamento layout fisico

## Task Attivi (In corso) 🛠️
- [x] **Game-Core Sync & Revamp**: Estrazione miglioramenti generici in `game-core` e rifacimento totale dei workflow per garantire disciplina (branching, commits, testing, docs).
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
- [x] **VRAM Texture Android**: Corretto import dello spritesheet da Lossless (`compress/mode=0`) a VRAM Compressed (`compress/mode=2`). Le GPU mobile richiedono texture ETC2/ASTC.
- [x] **Null Safety Texture**: Aggiunta protezione null su `sprite.texture` in Fruit.gd, NextQueue.gd e Slopdex.gd per prevenire crash se la texture non viene caricata.
- [x] **FileAccess → ResourceLoader**: Sostituito `FileAccess.file_exists()` con `ResourceLoader.exists()` in AudioManager.gd per compatibilità path `res://` su Android.

### [1.8.0] - 2026-05-14
- **Fix**: Risolto errore di parsing SPRITESHEET (circular dependency).
- **Fix**: Corretto percorso spritesheet.
- **Build**: Versione 1.8.0 con APK generato.

## 🛠 In Corso
- [ ] **Frullatore del Caos**: Implementazione abilità speciale attiva al 100% del Meter.