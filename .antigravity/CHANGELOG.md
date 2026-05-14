# Changelog

## [1.8.7] - 2026-05-14
### Fixed
- **Race Condition**: Prevented Pause Menu from opening during Game Over transitions.
- **Input Blocking**: TransitionManager now correctly blocks all mouse input during fades.
- **Double Click Protection**: GameOver buttons are now disabled immediately upon use.

## [1.8.6] - 2026-05-14
### Refactor
- **UIUtils**: Added unified utility for button interactions (hover/click) and pop-in animations.
- **AudioManager**: Implemented AudioStreamPlayer pooling (12 channels) for high-frequency SFX.
- **Menu Consistency**: Refactored `MainMenu`, `PauseMenu`, and `GameOver` to use centralized UI logic.
- **Clean Architecture**: Decoupled UI "juice" from business logic in menu scripts.

## [1.8.5] - 2026-05-14
### Refactor
- **FruitVisuals**: Centralized sprite mapping and scaling logic into a dedicated Autoload.
- **SaveManager**: Isolated all data persistence logic (progression.cfg) from Game/Score managers.
- **Code Quality**: Reduced duplication in `Fruit.gd`, `Spawner.gd`, and `NextQueue.gd`.
- **Warning Cleanup**: Suppressed unused signals in `EventBus` for a cleaner debugger.

## [1.8.4] - 2026-05-14
### Fixed
- Spawner position moved back below CringeLine (dead line) but above HUD to avoid overlaps.
- Fruit Queue in HUD now correctly excludes the fruit currently in "hand" (preview).
- Reverted Spawner movement and recoil to return to original launch behavior.
### Added
- Dynamic Fruit Preview Sprite on the Spawner.


### [1.8.3] - 2026-05-14
- **Reverted**: Rimosso il movimento orizzontale dello Spawner durante la mira.
- **Reverted**: Rimosso l'effetto di rinculo (recoil) durante il lancio.
- **Fixed**: Ripristinato il comportamento originale della mira fissa dal centro/basso, mantenendo la nuova preview del frutto.

### [1.8.2] - 2026-05-14
- **Added**: SlopEditor (v1.0) - Strumento web-based per la gestione degli asset.
- **Added**: "Zero-Step" Asset Workflow - Esportazione diretta in Godot senza modifiche al codice.
- **Added**: Supporto a mappatura frutti dinamica (infiniti tier supportati).
- **Added**: Supporto a "Visual Scale" per sprite indipendenti dal raggio di collisione.
- **Fixed**: Hitbox scaling in `Fruit.gd` (corretto allineamento visivo/fisico).
- **Refactor**: `NextQueue.gd` e `Slopdex.gd` ora utilizzano il sistema di mapping centralizzato.

### [1.8.1] - 2026-05-14
- **Feat**: Introdotto sistema `SpriteSheetLayout` per la gestione centralizzata e dinamica degli atlanti. Supporta griglie semplici, nidificate e mappature esplicite.
- **Refactor**: Rimosso calcolo manuale dei Rect2 da tutti i componenti UI e gameplay.
- **Easy-Swap**: Ora è possibile cambiare l'intero set grafico del gioco semplicemente sostituendo una risorsa `.tres` nel `GameManager`.

### [1.8.0] - 2026-05-14
- **Fix**: Ripristinata compressione VRAM (modalità 2) per compatibilità ottimale Android.
- **Fix**: Risolto bug critico case-sensitivity `Fruit.tscn` -> `fruit.tscn`.
- **Fix**: Corretto URL UpdateManager per puntare al branch `master`.
- **Cleanup**: Rimossi asset corrotti (`pause_icon.png`).
- **Build**: Versione 1.7.4 disponibile per update in-game.

### [1.7.4] - 2026-05-13
- **Fix**: Ripristinata compressione VRAM (modalità 2) per compatibilità ottimale Android.
- **Fix**: Risolto bug critico case-sensitivity `Fruit.tscn` -> `fruit.tscn`.
- **Fix**: Corretto URL UpdateManager per puntare al branch `master`.
- **Cleanup**: Rimossi asset corrotti (`pause_icon.png`).
- **Build**: Versione 1.7.4 disponibile per update in-game.

- [2026-05-13] **Fix (CRITICO)**: Risolto il bug delle texture invisibili su Android. La causa reale era `compress/mode=0` (Lossless) con `vram_texture: false` nel file `.import` dello spritesheet — le GPU mobile richiedono texture VRAM-compresse (ETC2/ASTC). Cambiato a `compress/mode=2` (VRAM Compressed) con `vram_texture: true`. Aggiunto null safety in Fruit.gd, NextQueue.gd e Slopdex.gd. Sostituito `FileAccess.file_exists()` con `ResourceLoader.exists()` in AudioManager.gd per compatibilità Android. Documentata la regola in CONVENTIONS_GODOT.md (§4.5 e §4.9).

- [2026-05-13] **Feat**: Implementato `UpdateManager`, un sistema di aggiornamento in-game non invasivo tramite file `version.json` remoto. Include:
  - Download diretto in-app con UI overlay (`ProgressBar` e status).
  - Permessi Android abilitati (`WRITE_EXTERNAL_STORAGE`, `REQUEST_INSTALL_PACKAGES`).
  - Installazione automatica su OS Android tramite intent.
  - Documentato il workflow di versioning e deploy in `CONVENTIONS.md`.

- [2026-05-13] ~~Fix: Forzato il compress/mode=0 (Lossless)~~ **REVERTED** — questa modifica era ERRATA e causava il bug delle texture invisibili su Android. La soluzione corretta è `compress/mode=2` (VRAM Compressed).

- [2026-05-13] Fix: Risolto bug visivo nella UI `NextQueue` che ometteva il frutto correntemente caricato nello Spawner, mostrando un offset nella coda dei frutti successivi.

- [2026-05-11] Revamp totale dei workflow e sincronizzazione con `game-core`. Introdotti step obbligatori per branching, testing e documentazione. Creata struttura `core/` generica.

## [1.7.0] - 2026-05-11
### Added
- **Full Fruit Progression**: Implementati tutti gli 11 tier di frutta con parametri di massa e raggio bilanciati.
- **Brainrot Naming**: Assegnati nomi a tema per tutti i nuovi frutti (es. Arancia Pazzoide, Melone Sigma, Anguria Skibidi).
### Changed
- **GameManager**: Sistema di caricamento dinamico per le risorse `FruitData`.

## [1.6.0] - 2026-05-11
### Fixed
- **Slopdex Crash**: Risolto crash critico causato dall'accesso alla proprietà inesistente `shared_texture` in `GameManager`. Sostituito con `SPRITESHEET`.
- **Fruit Launching**: Corretto il bug per cui la frutta non veniva spawnata dal `Spawner` a causa di proprietà non assegnate nell'inspector. Implementata inizializzazione automatica e randomizzazione del primo frutto (Starter Pool).
### Added
- **Fruit Randomizer**: Il `Spawner` ora seleziona casualmente il prossimo frutto tra i primi 3 tier (Pisello, Limone, Kiwi) dopo ogni lancio per variare il gameplay.

## [1.5.0] - 2026-05-11
### Optimized
- **Performance Mobile**: Sostituite le chiamate dinamiche a `load()` con `preload()` per le scene `Fruit` e `MergeVFX`, e per lo shader `SquishyFruit`. Ridotto drasticamente il micro-stutter durante le fusioni.
- **Debug Cleanup**: Il debug drawing dei cerchi di collisione è ora attivo solo nelle build di debug via `OS.is_debug_build()`.

### Refactored
- **PascalCase Standard**: Ridenominati tutti gli script principali in `PascalCase` (es. `GameManager.gd`, `EventBus.gd`, `Fruit.gd`) per conformità agli standard Godot.
- **Script References**: Aggiornati tutti i file `.tscn` e le impostazioni di Autoload per riflettere i nuovi nomi dei file.
- **Clean Code**: Sostituiti i riferimenti `get_node("/root/...")` con chiamate dirette ai Singleton per una sintassi più pulita e performante.
### Fixed
- **GameOver Navigation**: Risolto il bug critico per cui il tasto "Menu" ricaricava la scena e il "Restart" non funzionava correttamente. Implementata protezione contro il doppio trigger in `CringeLine` e impostato `PROCESS_MODE_ALWAYS` per i singleton di sistema (`GameManager`, `TransitionManager`).

## [1.4.0] - 2026-05-11
### Added
- **Menù di Pausa Premium**: Interfaccia con blur shader e animazioni di scala.
- **Volume Settings**: Implementati slider per il controllo del volume Master e SFX.
- **AudioManager Upgrade**: Aggiunta gestione dei bus audio tramite AudioServer.
- **Pause Icon**: Nuova icona neon cyan personalizzata per il tasto in HUD.

### Fixed
- Corretto errore di parsing in `pause_menu.tscn`.
- Ripristinato `ComboLabel` nel file `HUD.tscn`.

## [1.3.0] - 2026-05-11
### Added
- **Premium GameOver**: Upgrade grafico della schermata di sconfitta con blur shader e animazioni Tween.
- **Dashed CringeLine**: Shader personalizzato per la linea di pericolo tratteggiata con pulsazione dinamica.

### Fixed
- **Input Block**: Risolto bug che impediva il click dei tasti Restart/Menu durante la pausa.
- **Crash Prevention**: Implementato flag `is_game_over` per prevenire l'istanziamento infinito della UI.
- **Scene Parsing**: Corretto l'ordine dei tag nei file `.tscn` per caricamento corretto in Godot 4.

### Git
- Merge completo della feature nel branch `develop`.


Tutte le modifiche importanti a questo progetto saranno documentate in questo file.

## [1.1.0] - 2026-05-11
### Added
- **Pivot Meccanico**: Trasformazione in "Shoot & Bounce" shooter dal basso verso l'alto.
- **Upward Gravity**: Inversione della gravità globale per accumulo frutti sul soffitto.
- **AudioManager**: Gestione centralizzata suoni con pool di AudioStreamPlayer.
- **Cringe Line**: Logica di Game Over basata su timer di permanenza in zona critica.
- **Laser Power-up**: Meccanica di distruzione frutti tramite Raycast.
- **High Score**: Salvataggio persistente del miglior punteggio in `user://`.

### Changed
- **Spawner**: Convertito da drop orizzontale a mira direzionale con traiettoria a punti.
- **UI**: Aggiornamento HUD per supportare il nuovo loop di gioco.

### Fixed
- Corretto bug nel calcolo della regione dello sprite per la nuova spritesheet.
- Ottimizzati raggi di collisione nei file `.tres` per evitare sovrapposizioni visive.

## [1.2.0] - 2026-05-11
Versione Corrente: v1.8.7 (Bug Fix Release)
Stato: Fase 10 - Polish & Release (Completata)

## Milestone Recenti 🚀
- [x] **Fix Race Condition**: Risolto il bug "Restart + Pause" segnalato dall'utente.
- [x] **Unified UI Utility**: Tutte le animazioni bottoni centralizzate in `UIUtils`.

### Added
- **Sistema di Combo**: Tracciamento delle fusioni consecutive con moltiplicatori di punteggio.
- **Chain Events**: Segnalazione centralizzata delle catene di fusioni per UI e gameplay.
- **Brainrot Meter**: Barra di energia che si ricarica tramite combo, con stati di feedback visivo (Ready/Shake).
- **Floating Text System**: Feedback arcade immediato con etichette animate per combo (X2, Super, Brainrot).

### Changed
- **Risoluzione di Gioco**: Aumentata la risoluzione base a **1080x1920** (Full HD Portrait) per standard mobile moderni.
- **Main Scene**: Integrazione della UI per i testi fluttuanti e gestione coordinata delle coordinate mondo-UI.
- **Layout Fisico**: Adattati i confini (Boundaries) e lo Spawner per la nuova risoluzione.

### Fixed
- Corretto errore di parsing in Godot 4 per costanti Tween non esistenti (`TRANS_OUT`).
- Risolto bug di posizionamento iniziale dei testi fluttuanti che apparivano a (0,0).
- Ottimizzata la sensibilità del Brainrot Meter ai bonus di tier elevati.
