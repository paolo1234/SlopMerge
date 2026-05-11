# Changelog

- [2026-05-11] Revamp totale dei workflow e sincronizzazione con `game-core`. Introdotti step obbligatori per branching, testing e documentazione. Creata struttura `core/` generica.

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
