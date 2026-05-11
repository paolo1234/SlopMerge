---
name: fix
description: "Debugging e fixing di un problema"
---

# 🐞 Fix Flow

Questo workflow guida la risoluzione di un bug o errore.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Analisi Bug**: Leggi `.context/INSTRUCTIONS.md`, `.antigravity/STATE.md`. Riproduci il bug se possibile.
3. **Git Branching**: Crea un nuovo branch `fix/nome-bug` da `develop` (o `master` se è un hotfix).
4. **Pianificazione**: Elenca i file da modificare e la causa del bug. **Attendi conferma.**
5. **Esecuzione**: Sistema il bug seguendo le `.context/CONVENTIONS.md`.
6. **Validazione**:
   - Esegui `git diff`.
   - **Avvia il gioco** e verifica che il bug sia risolto.
7. **Commit Atomico**: `git add . && git commit -m "fix(scope): risolto bug [descrizione]"`.
8. **Documentazione (SYNC)**:
   - Aggiorna `.antigravity/STATE.md`.
   - Aggiorna `TASK.md` nella root.
   - Aggiungi entry in `.antigravity/CHANGELOG.md`.
9. **Merge**: Ritorna al branch di partenza e unisci il fix.
10. Aggiorna `.antigravity/STATE.md` — segna il fix come completato.
11. Aggiungi una entry in `.antigravity/CHANGELOG.md` con data e descrizione.