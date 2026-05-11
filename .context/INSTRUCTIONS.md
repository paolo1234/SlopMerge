# 📋 Istruzioni Operative per l'Agente (Godot 4)

> Questo file è il **punto di ingresso principale** dell'LLM. Deve essere letto prima di qualsiasi operazione.

---

## 🔁 Ordine Operativo (per ogni task)

1. **ANALISI** — Leggi `.antigravity/PROJECT_MAP.md` per capire la struttura attuale del progetto.
2. **GDD** — Leggi `.antigravity/GDD.md` per comprendere il Game Design Document e il contesto del gioco.
3. **IDENTITY** — Leggi `.antigravity/brand/IDENTITY.md` per comprendere il tono e l'identità del gioco.
4. **SKILLS** — Verifica le skill disponibili in `.antigravity/skills/` per ottimizzare le operazioni.
5. **CONTESTO** — Leggi `.antigravity/TECH_STACK.md` per le tecnologie in uso e `.antigravity/STATE.md` per lo stato corrente.
6. **REGOLE GODOT** — Leggi `.context/CONVENTIONS_GODOT.md` per le regole architetturali Godot-specifiche.
7. **MCP** — Usa l'MCP per leggere scene e script esistenti prima di scrivere codice.
8. **PIANO** — Proponi una lista di modifiche (scene da creare, script da modificare/creare, risorse `.tres`) e **attendi conferma** dell'utente prima di procedere.
9. **ESECUZIONE** — Scrivi codice seguendo le regole in `.context/CONVENTIONS.md`, `.context/CONVENTIONS_GODOT.md` e i pattern in `.antigravity/TECH_STACK.md`.
10. **VERIFICA** — Esegui `git diff` per controllare che non hai rotto funzionalità esistenti. Usa l'MCP per testare se possibile.
11. **SYNC & DOCUMENTATION** — Aggiorna i file di stato (OBBLIGATORIO):
    - `.antigravity/STATE.md` → segna il task come completato, aggiungi nuovi task/blocchi emersi.
    - `.antigravity/PROJECT_MAP.md` → aggiungi/rimuovi file e moduli se la struttura è cambiata.
    - `.antigravity/CHANGELOG.md` → aggiungi una entry con data e descrizione della modifica.
    - `TASK.md` (nella root) → segna il task come completato o in corso.
    - `.antigravity/GDD.md` → se hai introdotto un nuovo sistema core, aggiornalo.
12. **GIT COMMIT** — Esegui un commit descrittivo delle modifiche effettuate (`git add .` -> `git commit -m "..."`).
13. **TEST THE GAME** — Testa il gioco tramite MCP o manualmente per assicurarti che tutto funzioni correttamente. Se non funziona, sistema e ricomincia da 1. Chiedi conferma all'utente che tutto funzioni come dovrebbe, prima di procedere.
 
---

## ✅ Definizione di "Task Completato"

Un task è considerato completato **solo** quando:

1. Il codice è **funzionante**, con type hints GDScript corretti, privo di `print()` di debug.
2. La Scene Tree è stata proposta (diagramma ASCII) e confermata prima dell'implementazione.
3. I nuovi file/cartelle sono censiti in `PROJECT_MAP.md`.
4. `STATE.md` riporta cosa è stato fatto e quali debiti tecnici rimangono.
5. `CHANGELOG.md` contiene una entry per la modifica effettuata.
6. Le convenzioni in `CONVENTIONS.md` e `CONVENTIONS_GODOT.md` sono state rispettate.
7. Un `git diff` è stato eseguito per verificare zero-regression.

---

## 🛡 Regole di Sicurezza

- **Mai sovrascrivere** file senza prima averli letti e compresi.
- **Mai rimuovere** codice funzionante senza motivo esplicito e conferma dell'utente.
- **Mai introdurre** dipendenze o addon non necessari senza chiedere.
- **Segnalare** ogni debito tecnico creato in `STATE.md`.
- **Usare MCP** per leggere scene e script prima di ogni modifica.
- **Git diff** dopo ogni modifica per verificare che nulla sia stato rotto.

---

## 🚫 Guardrails Anti-Allucinazione

> Regole critiche per evitare errori causati da assunzioni errate dell'LLM.

- **Prima di importare** uno script o una scena → verifica che il file esista nel progetto (controlla `PROJECT_MAP.md` o il file system con MCP).
- **Prima di usare** un addon → verifica che sia installato nella cartella `addons/`.
- **Non creare cartelle** fuori dalla struttura definita in `PROJECT_MAP.md` senza prima chiedere all'utente.
- **Non assumere** che una scena, un autoload o un segnale esista — verifica in `PROJECT_MAP.md` e `GDD.md`.
- **Se non sei sicuro** → **CHIEDI** all'utente. Mai inventare.
- **Non duplicare** logica già esistente — cerca prima se esiste un componente, autoload o risorsa che fa già quello che serve.

---

## 📁 Mappa dei File di Configurazione

| File | Cartella | Scopo |
|---|---|---|
| `INSTRUCTIONS.md` | `.context/` | Questo file — ordine operativo |
| `CONVENTIONS.md` | `.context/` | Regole di codifica universali + Git branching |
| `CONVENTIONS_GODOT.md` | `.context/` | Regole architetturali Godot 4 + Mobile |
| `PROMPTS.md` | `.context/` | Indice dei protocolli e workflow |
| `PROJECT_MAP.md` | `.antigravity/` | Struttura, moduli e decisioni architetturali |
| `GDD.md` | `.antigravity/` | Game Design Document |
| `STATE.md` | `.antigravity/` | Stato avanzamento lavori |
| `TECH_STACK.md` | `.antigravity/` | Stack tecnologico del progetto |
| `CHANGELOG.md` | `.antigravity/` | Log cronologico delle modifiche |
| `settings.json` | `.gemini/` | Istruzioni auto-iniettate nell'LLM |