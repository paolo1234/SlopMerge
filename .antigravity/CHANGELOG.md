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
