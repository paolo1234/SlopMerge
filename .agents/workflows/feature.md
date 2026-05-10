---
description: Sviluppo di una nuova feature / sistema di gioco — Protocollo 1
---

# 🛠 Feature Flow (Godot 4)

Questo workflow guida lo sviluppo di una nuova feature o meccanica di gioco.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.context/CONVENTIONS_GODOT.md` per le regole architetturali Godot.
3. Leggi `.antigravity/GDD.md` per comprendere il contesto del gioco e verificare coerenza.
4. Leggi `.antigravity/brand/IDENTITY.md` per il tono e stile del gioco.
5. Verifica le Skill in `.antigravity/skills/` per ottimizzare lo sviluppo (es. `scene-architect`, `fsm-designer`, `game-feel-polish`).
6. Leggi `.context/CONVENTIONS.md` per le regole di codifica e Git.
7. Leggi `.antigravity/PROJECT_MAP.md` per la struttura scene/autoloads.
8. Leggi `.antigravity/TECH_STACK.md` per le tecnologie e configurazioni mobile.
9. Leggi `.antigravity/STATE.md` per lo stato corrente.
10. Usa l'MCP per leggere le scene e gli script correlati alla feature.
11. **Crea branch Git**: `git checkout -b feature/nome-sistema` da `develop`.
12. **Proponi Scene Tree** — diagramma ASCII della gerarchia dei nodi e spiegazione delle responsabilità. **Attendi conferma dell'utente.**
13. Elenca tutti i file che verranno creati o modificati (`.gd`, `.tscn`, `.tres`). **Attendi conferma.**
14. Scrivi il codice rispettando `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`.
15. **Git diff** — verifica che non hai rotto funzionalità esistenti.
16. **Commit atomico**: `git add . && git commit -m "feat(scope): descrizione"`.
17. **Game Feel Tip** — proponi almeno un consiglio per migliorare il feel della feature.
18. Aggiorna `.antigravity/STATE.md` — segna il task come completato.
19. Aggiorna `.antigravity/PROJECT_MAP.md` — aggiungi nuove scene/autoloads/resources.
20. Aggiorna `.antigravity/GDD.md` se hai introdotto un nuovo sistema core.
21. Aggiungi una entry in `.antigravity/CHANGELOG.md` con data e descrizione.
22. **Merge su develop**: `git checkout develop && git merge feature/nome-sistema && git branch -d feature/nome-sistema`.
