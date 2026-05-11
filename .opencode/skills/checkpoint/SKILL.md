---
name: checkpoint
description: "Salvataggio atomico e aggiornamento stato durante task lunghi"
---

# 🚩 Checkpoint Flow (Protocollo 10)

Questo workflow serve per "salvare" i progressi durante lo sviluppo di feature complesse che richiedono più passaggi. Evita di accumulare troppe modifiche senza commit o aggiornamenti di stato.

// turbo-all

## Steps

1. **Stato del Codice**: Assicurati che il codice attuale sia compilabile e non contenga errori critici.
2. **Validazione**: **Avvia il gioco** e verifica che la parte implementata finora funzioni correttamente.
3. **Commit Atomico**:
   - `git add .`
   - `git commit -m "feat(scope): progress checkout - [descrizione di cosa è stato fatto finora]"`
4. **Aggiornamento Documentazione**:
   - Aggiorna `STATE.md` indicando i sotto-task completati.
   - Aggiorna `TASK.md` segnando i progressi (`[/]` o `[x]`).
5. **Pianificazione Prossimo Step**: Identifica cosa manca per completare il task principale.
6. **Proseguimento**: Riprendi lo sviluppo del task.