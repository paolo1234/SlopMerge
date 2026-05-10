---
description: Allineamento contesto a inizio sessione — Protocollo 4
---

# 🔄 Context Sync (Godot 4)

Questo workflow sincronizza il contesto dell'agente ad inizio sessione.

// turbo-all

## Steps

1. Leggi il file `.context/INSTRUCTIONS.md`.
2. Leggi il file `.context/CONVENTIONS_GODOT.md`.
3. Leggi i file in `.antigravity/brand/` (Identity del gioco).
4. Verifica le Skill disponibili in `.antigravity/skills/`.
5. Leggi il file `.context/CONVENTIONS.md`.
6. Leggi il file `.antigravity/PROJECT_MAP.md`.
7. Leggi il file `.antigravity/GDD.md`.
8. Leggi il file `.antigravity/TECH_STACK.md`.
9. Leggi il file `.antigravity/STATE.md`.
10. Leggi il file `.antigravity/CHANGELOG.md`.
11. Verifica il **branch Git corrente**: `git branch --show-current`.
12. Fornisci un riassunto usando **esattamente** questo formato:

## Template Output

```markdown
# 🔄 Sync Contesto — [Nome Gioco]

## 🎯 Concept del Gioco
[1-2 frasi dal GDD.md — genere, meccanica principale, target]

## 📊 Stato Attuale
- **Branch Git corrente**: [branch]
- **Task completati di recente**: [ultimi 3-5 task da STATE.md]
- **Task correnti**: [task in corso con stato]
- **Prossimo passo suggerito**: [basato su priorità in STATE.md o roadmap GDD]

## 🚧 Blocchi e Rischi
- [Blocchi da STATE.md]
- [Debiti tecnici critici 🔴]

## ⚙️ Stack in Uso
- **Engine**: Godot [versione]
- **Linguaggio**: GDScript (strongly-typed)
- **Target**: [Mobile — Android/iOS]
- **Renderer**: [Mobile]

## 🏗 Architettura Attuale
[Riepilogo da PROJECT_MAP.md — scene principali, autoloads attivi, sistemi implementati]

## ✅ Pronto
Contesto caricato. Sono allineato e pronto a procedere.
Usa `/feature`, `/fix`, `/refactor`, o `/review` per iniziare.
```

13. Conferma di essere pronto a procedere.
