---
name: refactor
description: "Refactoring e pulizia del codice"
---

# 🧹 Refactor Flow

Questo workflow guida il refactoring e la pulizia del codice.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.antigravity/brand/IDENTITY.md` e `STYLING.md` per la Brand Identity (UI/Copy).
3. Verifica le Skill in `.antigravity/skills/` (es. `ui-generator`, `perf-profiler`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. Leggi `.antigravity/STATE.md` per lo stato.
6. Analizza il file/cartella target: identifica code smell, duplicazioni, file sopra le 200 righe.
7. Proponi le modifiche strutturali. **Attendi conferma dell'utente.**
8. Esegui il refactoring rispettando `.context/CONVENTIONS.md`:
   - Estrai la logica di business in file separati (utility, servizi).
   - Mantieni i componenti / controller "magri" (singola responsabilità).
   - Rimuovi codice morto e duplicato.
9. Aggiorna `.antigravity/PROJECT_MAP.md` se la struttura dei file è cambiata.
10. Aggiorna `.antigravity/STATE.md` e `.antigravity/CHANGELOG.md`.
