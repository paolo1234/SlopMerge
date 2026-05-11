---
name: bug_hunting
description: "Ricerca proattiva di bug e problemi nascosti — Protocollo 13"
---

# 🕵️ Bug Hunting Flow

Questo workflow è dedicato alla ricerca di problemi, glitch e inconsistenze nel gioco.

// turbo-all

## Steps

1. **Analisi Codice (Static Analysis)**:
   - Ricerca nel codice pattern pericolosi (es. riferimenti nulli, cicli infiniti, memory leaks potenziali).
   - Controlla i log di debug per errori silenziosi o avvisi.
2. **Test degli Angoli (Edge Cases)**:
   - Cosa succede se il giocatore preme tasti velocemente?
   - Cosa succede se il gioco viene messo in pausa durante una transizione?
   - Cosa succede se si verificano 10 fusioni contemporaneamente?
3. **Verifica UI/UX**:
   - Controlla allineamenti, sovrapposizioni e scalabilità su diverse risoluzioni.
   - Verifica la consistenza dei font e dei colori.
4. **Stress del Save System**: Corrompi o svuota il file di salvataggio per vedere come reagisce il gioco.
5. **Log dei Risultati**: Crea un artifact `bug_report.md` con i problemi trovati, classificati per priorità (Low, Medium, High).
6. **Pianificazione Fix**: Proponi all'utente quali problemi risolvere subito.
