# PROJECT MAP: Slop Merge

## Obiettivo del Gioco
Creare un puzzle game "Suika-like" che trattenga i giocatori attraverso un gameplay fisico iper-stimolante, meccaniche "salva-vita" ad-driven, un sistema di Shake con accelerometro, un "Brainrot Meter" (combo) e un solido metagame basato sul collezionismo (Pokedex) e Gacha per skin.

## Scene Principali
- **Main/Game**: La scena principale del loop di gioco (il contenitore, il GameManager, l'Input Handler).
- **Menu Principale**: Avvio del gioco, accesso al Gacha, al Pokedex e alle Daily Quests.
- **Fruit**: La scena base per le entità (RigidBody2D).
- **Gacha/Shop**: La schermata del distributore automatico.
- **Pokedex**: La galleria dei frutti scoperti.
- **UI Overlay**: Interfaccia di gioco (Punteggio, Brainrot Meter, Pulsanti Superpoteri).

## Autoloads (Singletons)
- **GameManager**: Gestisce lo stato globale (Score, Highscore, Valuta, Contatore Combo).
- **AdManager**: Sistema di intermediazione per Rewarded e Interstitial Ads.
- **SaveSystem**: Salvataggio/Caricamento locale (gettoni, skin sbloccate, pokedex).
- **AudioManager**: Code e canali audio per gestire il "suono caotico" senza clipping.
- **HapticManager**: Per unificare e standardizzare la vibrazione su Android/iOS.

## Architettura File System (res://)
```text
res://
├── assets/
│   ├── audio/ (sfx, music)
│   ├── fonts/
│   └── sprites/ (fruits, ui, backgrounds)
├── core/
│   ├── autoloads/ (GameManager, AdManager, ecc.)
│   └── components/ (StateMachines, Juice components)
├── scenes/
│   ├── entities/ (Fruit, Blender, ecc.)
│   ├── levels/ (Main container)
│   └── ui/ (HUD, MainMenu, Pokedex)
├── scripts/
│   ├── resources/ (CustomData per i frutti)
│   └── systems/ (Managers interni)
└── .antigravity/ (documentazione di design)
```