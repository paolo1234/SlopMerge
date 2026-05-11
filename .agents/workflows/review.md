---
name: review
description: "Revisione e analisi del codice"
---

# 🔍 Code Review Flow

Questo workflow guida la revisione del codice esistente senza modificarlo.

// turbo-all

## Steps

1. Leggi `.context/INSTRUCTIONS.md` per l'ordine operativo.
2. Leggi `.antigravity/brand/IDENTITY.md` e `STYLING.md` per la Brand Identity.
3. Verifica le Skill in `.antigravity/skills/` (es. `security-auditor`, `accessibility-checker`).
4. Leggi `.context/CONVENTIONS.md` per le regole di codifica.
5. Leggi `.antigravity/PROJECT_MAP.md` per la struttura.
6. Leggi `.antigravity/TECH_STACK.md` per le tecnologie.
7. **Analisi** — Esamina il file/cartella indicato e verifica la conformità a `.context/CONVENTIONS.md`.
8. **Report** — Produci un report strutturato seguendo il template:

## Template Report

```markdown
## 📊 Code Review — [Nome file/modulo]

### ✅ Punti Positivi
- [Cosa è fatto bene]

### Grafica
- [Come migliorare la grafica, la HUD, UI, effetti, altro se necessario in modo che sia adatto alla produzione e non sia solo un test]

### ⚠️ Problemi Trovati
| # | Severità | File | Riga | Descrizione |
|---|---|---|---|---|
| 1 | 🔴 Alta | `file.ts` | L42 | Descrizione problema |

### 🔒 Sicurezza
- [Vulnerabilità trovate o "Nessun problema rilevato"]

### ⚡ Performance
- [Colli di bottiglia o "Nessun problema rilevato"]

### 🧹 Suggerimenti di Refactoring
- [Miglioramenti consigliati con priorità]

### 📋 Conformità Convenzioni
- [Violazioni rispetto a CONVENTIONS.md]
```
8. Se richiesto dall'utente, registra i problemi critici in `.antigravity/STATE.md` come debiti tecnici.
