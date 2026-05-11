---
name: init
description: "Inizializzazione di un nuovo progetto"
---

# 🏗 Project Init

Questo workflow guida il setup iniziale dei file di contesto per un nuovo progetto.

## Steps

1. Chiedi all'utente:
   - Nome del progetto
   - Obiettivo / descrizione breve
   - Tech stack desiderato (framework, linguaggio, styling, ecc.)
   - Eventuali servizi esterni (database, auth, API, ecc.)
2. **Brainstorming & Analisi Critica**:
   - Analizza gli input ricevuti e produci un report critico.
   - Identifica potenziali rischi tecnologici o colli di bottiglia.
   - Proponi soluzioni alternative, pattern migliori o ottimizzazioni dello stack.
   - **Sfida** l'utente su eventuali incongruenze (es. "Vuoi usare X per fare Y, ma Z sarebbe più efficiente perché...").
3. **Approvazione Piano**:
   - Attendi che l'utente approvi il piano finale o richieda modifiche basate sul brainstorming.
   - **NON procedere** alla creazione dei file senza conferma esplicita.
4. Inizializza `.antigravity/brand/IDENTITY.md` e `STYLING.md` se disponibili o crea placeholder.
5. Popola `.antigravity/PROJECT_MAP.md`:
   - Inserisci l'obiettivo del progetto
   - Definisci i moduli core iniziali
   - Disegna l'architettura file system prevista
6. Popola `.antigravity/TECH_STACK.md`:
   - Inserisci lo stack scelto con versioni
   - Definisci le dipendenze principali
   - Imposta le variabili d'ambiente necessarie
7. Verifica / Crea cartelle se mancanti:
   - `.antigravity/brand/` (IDENTITY.md, STYLING.md)
   - `.antigravity/skills/` (scansione e setup)
8. Inizializza `.antigravity/STATE.md`:
   - Aggiungi il primo task: "Setup progetto iniziale"
9. Crea la prima entry in `.antigravity/CHANGELOG.md`:
   - `[data] — Inizializzazione progetto [nome]`
10. Conferma il setup completato e riepiloga la configurazione.