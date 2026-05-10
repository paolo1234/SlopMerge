# Changelog

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
