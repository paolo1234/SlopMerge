---
description: Gestione autonoma della roadmap e delle priorità — Protocollo 8
---

# 🤖 Autonomous Pilot Flow (Protocollo 8)

Questo workflow permette all'AI di decidere autonomamente il prossimo passo basandosi sulle priorità del progetto.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Analisi Roadmap**: Leggi `STATE.md`, `GDD.md`, `PROJECT_MAP.md` e `TASK.md`.
3. **Valutazione Priorità**:
   - Ci sono bug critici (🔴) in `STATE.md`? -> Esegui `/fix`.
   - C'è debito tecnico o UI da rifinire? -> Esegui `/upgrade`.
   - Manca una feature core della Fase attuale in `TASK.md`? -> Esegui `/feature`.
4. **Proposta Roadmap**: Presenta all'utente cosa hai deciso di fare e perché. Indica il branch che creerai.
5. **Esecuzione**: Una volta che l'utente approva, avvia il workflow appropriato (es. `/feature`).
6. **Sync Finale**: A lavoro ultimato, assicurati che `STATE.md`, `CHANGELOG.md` e `TASK.md` siano allineati.
7. **Report**: Proponi il task successivo.
