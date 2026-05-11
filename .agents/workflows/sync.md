---
name: sync
description: "Allineamento contesto a inizio sessione"
---

# 🔄 Context Sync

Questo workflow sincronizza il contesto dell'agente ad inizio sessione.

// turbo-all

## Steps

1. **Git Audit**: Esegui `git status` e `git branch` per identificare il branch attivo e lo stato della working directory.
2. **State Recovery**: Leggi `.antigravity/STATE.md` e `TASK.md` per capire quale task è attualmente attivo (🛠️).
3. **Context Loading**: Leggi `.context/INSTRUCTIONS.md`, `.context/CONVENTIONS.md`, `.antigravity/TECH_STACK.md`.
4. **Project Map**: Leggi `.antigravity/PROJECT_MAP.md` per la struttura file.
5. **Brand & Identity**: Leggi `.antigravity/brand/IDENTITY.md` e `STYLING.md`.
6. **Skill Audit**: Verifica le Skill disponibili in `.antigravity/skills/`.
7. **Report**: Fornisci un riassunto usando **esattamente** questo formato:

## Template Output

```markdown
# 🔄 Sync Contesto — [Nome Progetto]

## 🎯 Obiettivo del Progetto
[1-2 frasi dall'obiettivo in PROJECT_MAP.md]

## 📊 Stato Attuale
- **Task completati di recente**: [ultimi 3-5 task da STATE.md]
- **Task correnti**: [task in corso con stato]
- **Prossimo passo suggerito**: [basato su priorità in STATE.md]

## 🚧 Blocchi e Rischi
- [Blocchi da STATE.md]
- [Debiti tecnici critici 🔴]

## ⚙️ Stack in Uso
[Riepilogo da TECH_STACK.md — linguaggi, framework, servizi]

## ✅ Pronto
Contesto caricato. Sono allineato e pronto a procedere.
Usa `/feature`, `/fix`, `/refactor`, o `/review` per iniziare.
```

8. Conferma di essere pronto a procedere.
