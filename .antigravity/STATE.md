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
- [x] Sistema Slopdex (Galleria scoperte)
- [x] Sistema Wardrobe (Selezione Skin)
- [x] Implementazione Juice (Screen Shake & Particles)
- [x] Ottimizzazione Performance (Caching & Direct Refs)

## Task Attivi (In corso) 🛠️
- [ ] Sistema di reazioni a catena (Brainrot Meter refill)
- [ ] Power-up aggiuntivi (es. Slow Motion)
- [ ] Daily Quests base

## Debiti Tecnici ⚠️
- I raggi di collisione nei file `.tres` sono sottodimensionati rispetto agli sprite, causando sovrapposizioni.
- AudioManager non ha ancora i file audio reali.