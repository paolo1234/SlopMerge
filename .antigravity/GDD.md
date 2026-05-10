# Game Design Document (GDD): Slop Merge

## Concept del Gioco
Il giocatore lascia cadere dall'alto frutta antropomorfa e grottesca (generata da AI) in un contenitore. Frutti identici a contatto si fondono nel frutto di livello successivo. Se i frutti superano la "Linea del Cringe", la partita finisce. Focus estremo sulla sensazione "brainrot" e stimolazione visiva.

## Target Platform
- **Piattaforma**: Mobile (Android / iOS).
- **Orientamento**: Portrait (16:9 o ratio più allungati tipici degli smartphone moderni).
- **Risoluzione base**: 720x1280 (Expand / Canvas Items).
- **Input**: Touch screen (swipe per mirare, rilascio per droppare, tap sui powerup) e Accelerometro (Shake).

## Core Loop
1. **Drop**: Mira (swipe down) e rilascia.
2. **Merge**: Collisione basata su fisica elastica ("squishy").
3. **Evolve**: Animazioni succose, suoni "meme" esagerati, feedback aptico.
4. **Combo/Meter**: Riempimento barra Brainrot e attivazione Frullatore.
5. **Monetizzazione Act**: Guarda Ads per ottenere superpoteri (Raggio Traente, Shake extra, Salvataggi).

## Sistemi di Gioco Principali

### 1. Sistema Fisico e Input
- Fisica dei `RigidBody2D` per il rotolamento e incastro dei frutti.
- **Meccanica Originale: The Shake**. Usa i sensori del telefono per smuovere il contenitore fisicamente. Limite: 3 gratuiti per partita. Altri sbloccabili via Ad.

### 2. Brainrot Meter
- Una barra che si riempie con ogni fusione. Le fusioni a catena (combo) aumentano il moltiplicatore di riempimento.
- Al 100%, evoca il **Frullatore del Caos**: distrugge automaticamente i 3 frutti più piccoli sullo schermo (o i più fastidiosi se potenziato tramite Ad).

### 3. Sistema di Monetizzazione (Superpoteri)
- **Raggio Traente** (1 Ad): Solleva e riposiziona un frutto.
- **Preview Estesa** (1 Ad): Mostra i prossimi 3 frutti (invece di 1) per il resto della partita.
- **Respiro di Sollievo** (1 Ad): Quando vicini al Game Over, elimina il 25% del contenitore.
- **Moltiplicatore Punti** (1 Ad): A fine partita, x3 ai Gettoni Slop ottenuti.

### 4. Metagame e Ritenzione
- **Pokedex Cringe**: Collezione visiva di tutti i frutti scoperti, con sagome oscurate per creare FOMO.
- **Gacha System**: Macchinetta per scambiare "Gettoni Slop" per nuove Skin (es. Cyberpunk, Zombie).
- **Daily Quests**: Missioni ("Fai scontrare 50 mele", "Usa lo shake 5 volte") per sbloccare bauli. Reset ogni 24h.

## Performance Budget
- **Device Low-End**: Massimo X RigidBody attivi. I frutti fermi da troppo tempo potrebbero essere "addormentati" (Sleeping) finché non avviene un urto forte.
- **Particelle**: Limitare emettitori attivi simultanei. Usare ParticlePooling.
- **Audio**: Limitare i bus, massimo 2 "Vine Boom" al secondo per evitare saturazione della cassa audio.

## Roadmap & Milestones

- [ ] **Fase 1: Prototipo Core** (Fisica, Spawning, Merging di base).
- [ ] **Fase 2: Juiciness & Audio** (Shader squishy, particelle, suoni meme, haptic).
- [ ] **Fase 3: Meccaniche Originali** (Shake con accelerometro, Brainrot Meter e Frullatore).
- [ ] **Fase 4: Monetizzazione & Ads** (Superpoteri integrati con provider Ad).
- [ ] **Fase 5: Metagame** (Gacha, Pokedex, Gettoni Slop).
- [ ] **Fase 6: Polish & Quests** (Daily missions, ottimizzazione performance mobile).
