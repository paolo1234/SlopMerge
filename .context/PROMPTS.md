# 🚀 Protocolli Operativi — Quick Reference (Godot 4)

> Indice rapido dei protocolli. I workflow completi sono in `.agents/workflows/`.
> Usa i **slash commands** per attivare ciascun protocollo.

---

| Comando | Protocollo | Quando usarlo |
|---|---|---|
| `/feature` | 🛠 Sviluppo Nuova Feature | Creare un nuovo sistema/meccanica di gioco |
| `/fix` | 🐞 Debugging & Fixing | Qualcosa non funziona (bug, crash, regressione) |
| `/refactor` | 🧹 Refactoring & Pulizia | Migliorare scene/script esistenti |
| `/review` | 🔍 Code Review | Analizzare codice GDScript senza modificarlo |
| `/sync` | 🔄 Allineamento Contesto | Inizio nuova sessione di chat |
| `/init` | 🏗 Setup Nuovo Progetto | Inizializzare il progetto Godot da zero |

---

## Flusso Comune a Tutti i Protocolli

```
ANALISI (MCP + file) → PIANO (Scene Tree diagram + attendi OK) → ESECUZIONE → GIT DIFF → SYNC (aggiorna STATE, MAP, CHANGELOG, GDD)
```

## File di Riferimento

| Fase | File da consultare |
|---|---|
| Analisi | `.antigravity/PROJECT_MAP.md`, `.antigravity/GDD.md`, `.antigravity/brand/IDENTITY.md` |
| Piano | `.antigravity/TECH_STACK.md`, `.antigravity/STATE.md` |
| Esecuzione | `.context/CONVENTIONS.md`, `.context/CONVENTIONS_GODOT.md`, `.antigravity/skills/` |
| Verifica | `git diff` + MCP screenshot/test |
| Sync | `.antigravity/STATE.md`, `.antigravity/PROJECT_MAP.md`, `.antigravity/CHANGELOG.md`, `.antigravity/GDD.md` |