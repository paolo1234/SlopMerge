---
description: Inizializzazione di un nuovo progetto Godot 4 — Protocollo 5
---

# 🏗 Project Init (Godot 4)

Questo workflow guida il setup iniziale di un nuovo progetto Godot 4 per mobile.

## Steps

1. **Raccolta Input**:
   - Chiedi il **Nome del gioco**.
   - Chiedi una **Descrizione dell'idea di gioco** (genere, meccanica principale, riferimenti).
   - Chiedi l'**orientamento** (portrait/landscape).
   - Chiedi se l'utente ha già in mente un **genere, stile visivo o ispirazioni**, altrimenti guida un brainstorming.
2. **Brainstorming & Analisi Architetturale**:
   - Analizza l'idea e popola un report di brainstorming.
   - **Obbligatorio**: Proponi **almeno 3 approcci architetturali possibili** (es: Component-based con FSM, ECS-like, Scene-based puro, etc.).
   - Per ogni opzione, elenca chiaramente:
     - **Punti di Forza** (perché sceglierla).
     - **Punti di Debolezza** (potenziali colli di bottiglia o limiti).
     - **Scene Tree consigliato** (diagramma ASCII).
   - Identifica eventuali rischi tecnici per mobile (performance, input, risoluzione).
3. **Scelta e Approvazione**:
   - Discuti con l'utente per scegliere l'opzione migliore o mixare le idee.
   - **NON procedere** alla creazione dei file senza l'approvazione esplicita.
4. **Git Init & Branching**:
   - Inizializza il repository Git: `git init`
   - Crea il file `.gitignore` per Godot
   - Crea il primo commit su `master`: `chore: initial project setup`
   - Crea il branch `develop`: `git checkout -b develop`
5. Inizializza `.antigravity/brand/IDENTITY.md` con genere, target, tono e riferimenti.
6. Popola `.antigravity/PROJECT_MAP.md`:
   - Inserisci l'obiettivo del gioco
   - Definisci le scene principali e gli autoloads
   - Disegna l'architettura file system `res://`
7. Popola `.antigravity/GDD.md`:
   - Concept del gioco
   - Target platform (orientamento, risoluzione, input)
   - Core loop
   - Sistemi di gioco iniziali (anche solo pianificati)
   - Performance budget
   - Roadmap con milestones
8. Popola `.antigravity/TECH_STACK.md`:
   - Conferma Godot 4.x + GDScript
   - Configura viewport e stretch settings
   - Inserisci eventuali addon/plugin
9. Inizializza `.antigravity/STATE.md`:
   - Aggiungi i primi task dalla roadmap del GDD
10. Crea la prima entry in `.antigravity/CHANGELOG.md`:
    - `[data] — Inizializzazione progetto [nome]`
11. Conferma il setup completato e riepiloga la configurazione.
