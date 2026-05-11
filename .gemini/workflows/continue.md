---
description: Ripristino del contesto e prosecuzione dell'ultimo task — Protocollo 9
---

# ⏯️ Continue Flow (Protocollo 9)

Questo workflow permette di riprendere lo sviluppo di un task interrotto, assicurandosi di non perdere il filo e di seguire la pianificazione esistente.

// turbo-all

## Steps

1. **Sincronizzazione Base**: Esegui `/sync` per caricare lo stato attuale.
2. **Analisi Branch**: 
   - Esegui `git branch --show-current` per identificare il branch attivo.
   - Esegui `git status` per vedere modifiche non ancora committate.
3. **Analisi Progressi**:
   - Leggi `STATE.md` per trovare il task contrassegnato come "In corso" (🛠️ o [/]).
   - Leggi `TASK.md` per vedere quali sotto-task della fase attuale mancano.
   - Esegui `git diff` o leggi gli ultimi commit per capire a che punto è il codice.
4. **Ripristino Piano**:
   - Riassumi brevemente cosa è già stato fatto.
   - Identifica il **prossimo step immediato** secondo la pianificazione originale.
5. **Esecuzione**: Riprendi lo sviluppo seguendo il workflow originale (`/feature`, `/fix`, ecc.) ma saltando la fase di inizializzazione/branching se già fatta.
6. **Validazione**: Testa periodicamente con l'MCP per assicurarti di essere sulla strada giusta.
