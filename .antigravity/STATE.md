# Stato Attuale del Progetto: Slop Merge

- [x] Sistema di reazioni a catena: Refill dinamico del Brainrot Meter e feedback arcade (Floating Text).

## Task Completati ✅
- [x] Setup struttura cartelle base in `res://`
- [x] Creazione risorsa Custom `FruitData` per i parametri dei frutti
- [x] Prototipo scena `Fruit` (RigidBody2D + Shader Squishy + Region Sprite)
- [x] Implementazione Spawner (Mira direzionale, Lancio dal basso)
- [x] Pivot Meccanico: Gravità invertita (Upward Physics)
- [x] UI Brainrot Meter (Base) e sistema di combo dinamico
- [x] AudioManager e integrazione suoni (pool di player)
- [x] Logica di Game Over (Cringe Line) e High Score persistente
- [x] Transizioni tra scene (TransitionManager Fade)
- [x] Sistema Gacha base (Estrazione Skin)
- [x] Persistenza Skin e Valuta (savegame.cfg)
- [x] UI Main Menu aggiornata con Gacha
- [x] Sistema Slopdex (Galleria scoperte)
- [x] Sistema Wardrobe (Selezione Skin)
- [x] Implementazione Juice (Screen Shake & Particles)
- [x] Ottimizzazione Performance (Caching & Direct Refs)
- [x] Fix raggi di collisione nei file .tres (allineamento con sprite)
- [x] Sistema di Reazioni a Catena: Floating Text e Combo Multipliers
- [x] Upgrade Risoluzione: Porting a 1080x1920 (Full HD Mobile) e adattamento layout fisico

## Task Attivi (In corso) 🛠️
- [ ] **Frullatore del Caos**: Implementazione abilità speciale attiva al 100% del Meter.
- [ ] **Power-up Magnete**: Raggio traente per riposizionare frutti (Ads rewarded).
- [ ] **Power-up Slow Motion**: Rallentamento temporaneo del tempo.
- [ ] **Daily Quests base**: Sistema di missioni giornaliere per guadagnare gettoni.

## Debiti Tecnici ⚠️
- AudioManager non ha ancora i file audio reali (usa placeholder/null).
- Mancano i tier di frutta dal 4 all'11 (implementati solo i primi 3).