---
description: Debugging e fixing di un problema — Protocollo 2
---

# 🐞 Fix Flow (Godot 4)

Questo workflow guida la risoluzione di un bug o errore nel progetto Godot.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.context/CONVENTIONS_GODOT.md` per le regole architetturali Godot.
3. Verifica le Skill in `.antigravity/skills/` (es. `error-optimizer`, `perf-profiler`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura scene/autoloads.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. Leggi `.antigravity/STATE.md` per lo stato.
8. Usa l'MCP per leggere le scene e gli script coinvolti nel bug.
9. **Crea branch Git** (se fix complesso): `git checkout -b fix/nome-bug` da `develop`.
10. Esegui una **Root Cause Analysis**: riproduci mentalmente il flusso dell'errore, identifica la causa analizzando il Scene Tree e il codice.
11. Proponi la correzione, specificando i file coinvolti e le modifiche. **Attendi conferma dell'utente.**
12. Applica il fix rispettando `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`.
13. **Git diff** — verifica che il fix non rompa funzionalità esistenti (zero-regression).
14. **Commit atomico**: `git add . && git commit -m "fix(scope): descrizione"`.
15. Aggiorna `.antigravity/STATE.md` — segna il fix come completato.
16. Aggiungi una entry in `.antigravity/CHANGELOG.md` con data e descrizione.
17. **Merge su develop**: `git checkout develop && git merge fix/nome-bug && git branch -d fix/nome-bug`.
