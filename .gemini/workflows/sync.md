---
name: sync
description: "Allineamento contesto a inizio sessione"
---

# 🔄 Context Sync

Questo workflow sincronizza il contesto dell'agente ad inizio sessione.

// turbo-all

## Steps

1. Leggi il file `.context/INSTRUCTIONS.md`.
2. Leggi i file in `.antigravity/brand/` (Identity e Styling).
3. Verifica le Skill disponibili in `.antigravity/skills/`.
4. Leggi il file `.context/CONVENTIONS.md`.
5. Leggi il file `.antigravity/PROJECT_MAP.md`.
6. Leggi il file `.antigravity/TECH_STACK.md`.
7. Leggi il file `.antigravity/STATE.md`.
8. Leggi il file `.antigravity/CHANGELOG.md`.
7. Fornisci un riassunto usando **esattamente** questo formato:

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
