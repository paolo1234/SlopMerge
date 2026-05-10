---
description: Gestione autonoma della roadmap e delle priorità — Protocollo 8
---

# 🤖 Autonomous Pilot Flow (Protocollo 8)

Questo workflow permette all'AI di decidere autonomamente il prossimo passo basandosi sulle priorità del progetto.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` (Protocollo 4) per allineare il contesto.
2. **Analisi Roadmap**: Leggi `STATE.md`, `GDD.md` e `PROJECT_MAP.md`.
3. **Valutazione Priorità**:
   - Ci sono bug critici (🔴)? -> Esegui `/fix`.
   - C'è debito tecnico o UI da rifinire? -> Esegui `/upgrade`.
   - Manca una feature core della Fase attuale? -> Esegui `/feature`.
4. **Proposta Roadmap**: Presenta all'utente cosa hai deciso di fare e perché.
5. **Esecuzione**: Una volta che l'utente dice "Procedi" o simile, avvia il workflow appropriato.
6. **Report Finale**: A lavoro ultimato, aggiorna la documentazione e proponi il task successivo.
