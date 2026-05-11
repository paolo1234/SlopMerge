# 📘 Guida allo Sviluppo Agentico (Godot 4)

Questa guida spiega come utilizzare i workflow e il sistema Antigravity per sviluppare il gioco senza errori, dimenticanze o regressioni.

## 🚀 Il Ciclo di Vita di una Sessione

Ogni volta che inizi a lavorare, segui questo ordine:

1.  **`/sync`**: Carica il contesto. Non assumere mai di sapere cosa stavi facendo.
2.  **`/continue`** o **`/auto`**: 
    - Usa `/continue` se sai che c'era un task in corso.
    - Usa `/auto` se vuoi che l'AI valuti le priorità.

---

## 🛠️ Regole d'Oro della Disciplina

Per evitare i problemi segnalati (dimenticanze, branch inutili, mancati test), seguiamo queste regole:

### 1. Branching Rigoroso
- **MAI** lavorare su `master` o `develop`.
- Ogni task (`/feature`, `/fix`, `/upgrade`) **DEVE** avere il suo branch: `tipo/nome-task`.
- Il workflow ti chiederà di crearlo. Se non lo fa, fallo tu.

### 2. Sincronizzazione Documentale
La documentazione (`STATE.md`, `CHANGELOG.md`, `TASK.md`) non è un optional. È la "memoria a breve termine" dell'AI.
- **Se non aggiorni lo stato, l'AI si perderà alla prossima sessione.**
- Ogni workflow ha step obbligatori per questo.

### 3. Test Prima del Commit
- Non fidarti mai del codice appena scritto.
- **Avvia sempre il gioco** prima di fare commit.
- Usa l'MCP per verificare scene e log.

### 4. Commit Atomici
- Fai commit piccoli e frequenti. 
- Se un task è troppo lungo, usa `/checkpoint` per salvare i progressi intermedi.

---

## 📋 Mappa dei Workflow (Protocolli)

| Comando | Protocollo | Quando usarlo |
|---|---|---|
| `/sync` | 4 | Inizio sessione |
| `/continue` | 9 | Riprendere un task interrotto |
| `/auto` | 8 | Gestione autonoma roadmap |
| `/feature` | 1 | Nuova meccanica o scena |
| `/fix` | 2 | Correzione bug |
| `/upgrade` | 7 | Miglioramento/Raffinamento |
| `/refactor` | 3 | Pulizia codice |
| `/checkpoint` | 10 | Salvare progressi intermedi |
| `/review` | 6 | Analisi e report del codice |
| `/init` | 5 | Nuovo progetto |

---

## 🛡️ Guardrails Anti-Errore
- **Analisi prima della modifica**: Leggi sempre i file correlati prima di toccarli.
- **Pianificazione approvata**: Non scrivere codice finché l'utente non ha confermato il piano.
- **Zero-Regression**: Esegui `git diff` dopo ogni modifica per vedere cosa è cambiato davvero.
