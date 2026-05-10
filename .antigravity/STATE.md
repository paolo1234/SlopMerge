# Stato Attuale del Progetto: Slop Merge

## Task Completati ✅
- [x] Setup struttura cartelle base in `res://`
- [x] Creazione risorsa Custom `FruitData` per i parametri dei frutti
- [x] Prototipo scena `Fruit` (RigidBody2D + Shader Squishy + Region Sprite)
- [x] Implementazione Spawner (Mira direzionale, Lancio dal basso)
- [x] Pivot Meccanico: Gravità invertita (Upward Physics)
- [x] UI Brainrot Meter e sistema di merge
- [x] AudioManager e integrazione suoni (pool di player)
- [x] Logica di Game Over (Cringe Line) e High Score persistente
- [x] Fase 5: Raffinamento & Metagame 🛠️
- [x] Transizioni tra scene (TransitionManager Fade)
- [x] Sistema Gacha base (Estrazione Skin)
- [x] Persistenza Skin e Valuta
- [x] UI Main Menu aggiornata con Gacha

## Task Attivi (In corso) 🛠️
- [ ] Bilanciamento raggio collisioni (Risoluzione sovrapposizione frutti)
- [ ] Implementazione effettiva delle Skin visuali sui frutti
- [ ] Sistema di reazioni a catena (Brainrot Meter refill)
- [ ] Pokedex/Galleria frutti
- [ ] Implementazione Power-up "Laser Beam" (completamento feedback visivo)
- [ ] Rifinitura Trajectory Line (animazione o particelle)

## Debiti Tecnici ⚠️
- I raggi di collisione nei file `.tres` sono sottodimensionati rispetto agli sprite, causando sovrapposizioni.
- AudioManager non ha ancora i file audio reali.