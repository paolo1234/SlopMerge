---
description: Revisione e analisi del codice — Protocollo 6
---

# 🔍 Code Review Flow (Godot 4)

Questo workflow guida la revisione del codice GDScript e delle scene esistenti senza modificarle.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.context/CONVENTIONS_GODOT.md` per le regole architetturali Godot.
3. Verifica le Skill in `.antigravity/skills/` (es. `gdscript-patterns`, `perf-profiler`, `error-optimizer`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura scene/autoloads.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. Usa l'MCP per leggere le scene e gli script da analizzare.
8. **Analisi** — Esamina il file/scena indicato e verifica la conformità a `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`.
9. **Report** — Produci un report strutturato seguendo il template:

## Template Report

```markdown
## 📊 Code Review — [Nome script/scena]

### ✅ Punti Positivi
- [Cosa è fatto bene]

### ⚠️ Problemi Trovati
| # | Severità | File | Riga | Descrizione |
|---|---|---|---|---|
| 1 | 🔴 Alta | `Script.gd` | L42 | Descrizione problema |

### 🏗 Architettura
- [ ] Component Pattern rispettato?
- [ ] "Call down, signal up" rispettato?
- [ ] Nessun `get_parent().get_node()` hardcoded?
- [ ] FSM implementata correttamente (se presente)?

### 🎮 Game Feel
- [ ] Feedback visivi presenti per azioni utente?
- [ ] Audio cue presenti?
- [ ] Haptic feedback su mobile (se applicabile)?

### 📱 Mobile Compliance
- [ ] Touch input gestito (non solo mouse)?
- [ ] Target area ≥ 44×44 dp?
- [ ] Nessuna allocazione in _process()?
- [ ] Texture ≤ 2048×2048?

### ⚡ Performance
- [Colli di bottiglia o "Nessun problema rilevato"]

### 🔤 Type Safety
- [ ] Tutti gli script hanno type hints?
- [ ] Tutti i `func` hanno `-> void` o return type?

### 🧹 Suggerimenti di Refactoring
- [Miglioramenti consigliati con priorità]

### 📋 Conformità Convenzioni
- [Violazioni rispetto a CONVENTIONS.md e CONVENTIONS_GODOT.md]
```
10. Se richiesto dall'utente, registra i problemi critici in `.antigravity/STATE.md` come debiti tecnici.
