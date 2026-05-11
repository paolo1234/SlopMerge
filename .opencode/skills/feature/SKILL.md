---
name: feature
description: "Sviluppo di una nuova feature"
---

# 🛠 Feature Flow

Questo workflow guida lo sviluppo di una nuova feature.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Analisi**: Leggi `.context/INSTRUCTIONS.md`, `.antigravity/PROJECT_MAP.md`, `.antigravity/TECH_STACK.md`, `.antigravity/STATE.md`.
3. **Pianificazione**:
   - Identifica le cartelle di destinazione.
   - Proponi il Scene Tree (ASCII) se crei una scena.
   - Elenca i file da creare/modificare.
   - **Attendi conferma dell'utente.**
4. **Git Branching**: Crea un nuovo branch `feature/nome-feature` partendo da `develop`.
5. **Esecuzione**: Scrivi il codice seguendo le `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`.
6. **Validazione & Test**:
   - Esegui `git diff` per verificare le modifiche.
   - **Avvia il gioco** tramite Godot/MCP e verifica che la feature funzioni e non ci siano regressioni.
7. **Commit Atomico**: `git add . && git commit -m "feat(scope): descrizione della nuova feature"`.
8. **Documentazione (SYNC)**:
   - Aggiorna `.antigravity/STATE.md` (task completato).
   - Aggiorna `TASK.md` nella root.
   - Aggiorna `.antigravity/PROJECT_MAP.md` (nuovi file).
   - Aggiungi entry in `.antigravity/CHANGELOG.md`.
9. **Merge**: Ritorna su `develop` e unisci il branch (o chiedi all'utente di farlo).