---
name: refactor
description: "Refactoring e pulizia del codice"
---

# 🧹 Refactor Flow

Questo workflow guida il refactoring e la pulizia del codice.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Analisi**: Leggi `.context/INSTRUCTIONS.md`, `.context/CONVENTIONS.md`, `.antigravity/PROJECT_MAP.md`.
3. **Pianificazione**:
   - Identifica il codice da rifattorizzare.
   - Proponi il nuovo design senza cambiare funzionalità.
   - **Attendi conferma.**
4. **Git Branching**: Crea un nuovo branch `refactor/descrizione` da `develop`.
5. **Esecuzione**: Applica il refactoring mantenendo la compatibilità.
6. **Validazione**:
   - Esegui `git diff`.
   - **Avvia il gioco** e verifica che tutto funzioni esattamente come prima.
7. **Commit Atomico**: `git add . && git commit -m "refactor(scope): descrizione del refactoring"`.
8. **Documentazione (SYNC)**:
   - Aggiorna `.antigravity/STATE.md`.
   - Aggiungi entry in `.antigravity/CHANGELOG.md`.
9. **Merge**: Ritorna su `develop` e unisci il branch.
10. Analizza il file/cartella target: identifica code smell, duplicazioni, file sopra le 200 righe.
11. Proponi le modifiche strutturali. **Attendi conferma dell'utente.**
12. Esegui il refactoring rispettando `.context/CONVENTIONS.md`:
   - Estrai la logica di business in file separati (utility, servizi).
   - Mantieni i componenti / controller "magri" (singola responsabilità).
   - Rimuovi codice morto e duplicato.
13. Aggiorna `.antigravity/PROJECT_MAP.md` se la struttura dei file è cambiata.
14. Aggiorna `.antigravity/STATE.md` e `.antigravity/CHANGELOG.md`.