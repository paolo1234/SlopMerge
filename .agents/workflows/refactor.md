---
description: Refactoring e pulizia del codice — Protocollo 3
---

# 🧹 Refactor Flow (Godot 4)

Questo workflow guida il refactoring e la pulizia di scene e script Godot.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.context/CONVENTIONS_GODOT.md` per le regole architetturali Godot.
3. Verifica le Skill in `.antigravity/skills/` (es. `scene-architect`, `perf-profiler`, `gdscript-patterns`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura scene/autoloads.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. Leggi `.antigravity/STATE.md` per lo stato.
8. Usa l'MCP per leggere le scene e gli script da refactorare.
9. **Crea branch Git**: `git checkout -b refactor/descrizione` da `develop`.
10. Analizza il file/scena target: identifica code smell, script sopra le 200 righe, violazioni Component Pattern, mancanza di type hints, nodi con responsabilità multiple.
11. Proponi le modifiche strutturali. **Attendi conferma dell'utente.**
12. Esegui il refactoring rispettando `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`:
    - Estrai la logica in componenti figli separati (Component Pattern).
    - Spezza script monolitici in script più piccoli.
    - Sostituisci dati hardcodati con Custom Resources `.tres`.
    - Aggiungi type hints mancanti.
    - Rimuovi codice morto e duplicato.
    - Correggi violazioni "call down, signal up".
13. **Git diff** — verifica zero-regression.
14. **Commit atomico**: `git add . && git commit -m "refactor(scope): descrizione"`.
15. Aggiorna `.antigravity/PROJECT_MAP.md` se la struttura dei file è cambiata.
16. Aggiorna `.antigravity/STATE.md` e `.antigravity/CHANGELOG.md`.
17. **Merge su develop**: `git checkout develop && git merge refactor/descrizione && git branch -d refactor/descrizione`.
