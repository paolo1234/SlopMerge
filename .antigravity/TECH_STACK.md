# Tech Stack: Slop Merge

## Engine e Linguaggio
- **Engine**: Godot 4.3 (o versione più recente compatibile).
- **Linguaggio**: GDScript.

## Configurazione Viewport
- **Risoluzione Finestra**: 720 x 1280.
- **Orientation**: Portrait.
- **Stretch Mode**: Canvas Items / Expand.

## Architettura Dati
- **Frutti**: Ibrido Component-Based / Data-Driven (Uso di `Resource` per definire i vari tier di frutta, uso di `RigidBody2D` per la fisica, componenti separati per input e succosità).
- **Loop Principale**: Manager Pattern (`GameManager` autoload globale) per punteggi, barra Brainrot, combo e Ads.

## Plugin & Integrazioni Future (Pianificate)
- AdMob / Plugin pubblicitario nativo per Rewarded Ads e Interstitial.
- Plugin per l'utilizzo avanzato dei sensori fisici (Accelerometro per lo Shake) se necessario per calibrazione accurata.