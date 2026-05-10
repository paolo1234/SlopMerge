---
name: fix
description: "Debugging e fixing di un problema"
---

# 🐞 Fix Flow

Questo workflow guida la risoluzione di un bug o errore.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.antigravity/brand/IDENTITY.md` e `STYLING.md` per la Brand Identity (UI/Copy).
3. Verifica le Skill in `.antigravity/skills/` (es. `error-optimizer`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. Leggi `.antigravity/STATE.md` per lo stato.
6. Esegui una **Root Cause Analysis**: riproduci mentalmente il flusso dell'errore e identifica la causa.
7. Proponi la correzione, specificando i file coinvolti e le modifiche. **Attendi conferma dell'utente.**
8. Applica il fix rispettando `.context/CONVENTIONS.md`.
9. Verifica che il fix non rompa funzionalità esistenti e non contrasti con `.antigravity/TECH_STACK.md`.
10. Aggiorna `.antigravity/STATE.md` — segna il fix come completato.
11. Aggiungi una entry in `.antigravity/CHANGELOG.md` con data e descrizione.
