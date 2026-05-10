# 📖 Guida allo Sviluppo di Videogiochi con Antigravity IDE & Godot 4

> Questo tutorial spiega come utilizzare il sistema di contesto per sviluppare videogiochi Godot 4 in modo strutturato e produttivo con l'aiuto di un IDE agentico (Antigravity, Opencode).

---

## 🏗 Architettura del Sistema

Il setup è diviso in **4 cartelle**, ciascuna con un ruolo preciso:

```
progetto-gioco/
├── .gemini/          ← Istruzioni auto-iniettate nell'LLM (invisibili, sempre attive)
├── .context/         ← Regole permanenti (generiche + Godot-specifiche)
├── .antigravity/     ← Stato del progetto (specifico, mutabile)
│   ├── brand/        ← Game Identity (genere, tono, riferimenti)
│   ├── skills/       ← Skill specializzate per gamedev
│   └── ...
└── .agents/          ← Workflow automatizzati (slash commands)
```

| Cartella | Modificare? | Copiabile in altri progetti? |
|---|---|---|
| `.gemini/` | Mai | ✅ Sì |
| `.context/` | Raramente (solo per aggiungere regole) | ✅ Sì |
| `.antigravity/` | Sempre (l'LLM lo aggiorna ad ogni task) | ⚠️ Solo come template vuoto |
| `.agents/` | Raramente (solo per aggiungere workflow) | ✅ Sì |
| `.antigravity/brand/` | Quando cambi genere/tono del gioco | ✅ Sì |
| `.antigravity/skills/` | Quando servono nuove competenze | ✅ Sì |

---

## 🎮 Game Identity & 🛠 Skills

### 🎮 Game Identity (`.antigravity/brand/`)
Prima di generare qualsiasi sistema o scena, l'agente consulta:
- `IDENTITY.md`: L'identità del gioco (genere, target, tono, riferimenti).

### 🛠 Skill Specializzate (`.antigravity/skills/`)
L'agente ha accesso a **10 Skill** che contengono istruzioni avanzate per compiti specifici:
1.  **Scene Architect**: Progettazione Scene Tree ottimali con Component Pattern.
2.  **GDScript Patterns**: Pattern GDScript idiomatici con type hints obbligatori.
3.  **FSM Designer**: Finite State Machines per player, nemici, UI.
4.  **Game Feel & Polish**: Juice effects, screen shake, haptic feedback mobile.
5.  **Perf Profiler**: Ottimizzazione performance per mobile (60 FPS target).
6.  **Audio Designer**: Sistema audio con bus, pool, e ottimizzazioni mobile.
7.  **Resource System**: Custom Resources `.tres` per dati configurabili.
8.  **Error Optimizer**: Gestione errori robusta in GDScript.
9.  **Doc Automatizer**: Auto-documentazione di GDD, scene, e stato progetto.
10. **Test Generator**: Unit testing con GUT framework.

> **Nota**: Non devi attivare le skill manualmente; l'agente le consulta automaticamente quando il task lo richiede.

---

## 🚀 Come Iniziare un Nuovo Progetto

### Passo 1 — Copia i file
Copia queste **3 cartelle** nella root del nuovo progetto Godot:
- `.context/`
- `.agents/`
- `.gemini/`

Poi copia `.antigravity/` (i file sono template vuoti da popolare).

### Passo 2 — Inizializza il progetto
Apri Antigravity e scrivi:

```
/init
```

L'LLM ti chiederà i dettagli del gioco (nome, genere, meccaniche, stile visivo).
**Fase di Brainstorming**
Prima di scrivere qualsiasi file, l'agente effettuerà un'**analisi architetturale** delle tue scelte, proponendo almeno 3 approcci diversi con Scene Tree, pro e contro. Dovrai confermare il piano finale prima che l'agente proceda.

L'agente inoltre:
- Inizializzerà Git con branching model (master/develop)
- Creerà il `.gitignore` per Godot
- Popolerà il `GDD.md` con concept, core loop, e roadmap

### Passo 3 — Sei pronto!
Da questo momento, usa i comandi slash per lavorare.

---

## ⚡ Comandi Disponibili

| Comando | Quando usarlo | Cosa fa |
|---|---|---|
| `/init` | Inizio progetto | Compila GDD, PROJECT_MAP, TECH_STACK, init Git |
| `/sync` | Inizio sessione di chat | L'LLM rilegge tutto il contesto e ti fa il punto |
| `/feature` | Vuoi creare un nuovo sistema/meccanica | Guida lo sviluppo con Scene Tree + branch Git |
| `/fix` | Qualcosa non funziona (bug, crash) | Guida il debug con MCP + root cause analysis |
| `/refactor` | Vuoi migliorare codice/scene esistenti | Guida il refactoring con Component Pattern |
| `/review` | Vuoi analizzare codice senza modifiche | Code review con checklist Godot + mobile |

---

## 📋 Flusso di Lavoro Quotidiano

### 1. Inizio sessione → `/sync`

Ogni volta che apri una nuova chat con l'LLM, scrivi `/sync`. Questo forza l'agente a:
- Rileggere tutti i file di configurazione
- Leggere il GDD per capire il contesto del gioco
- Verificare il branch Git corrente
- Farti un riassunto dello stato del progetto

> **Perché?** L'LLM non ha memoria tra le sessioni. `/sync` gli ridà il contesto.

### 2. Sviluppo → `/feature`

Quando vuoi aggiungere un sistema o una meccanica:

```
/feature
Voglio implementare il sistema di movimento del player con joystick virtuale per mobile.
```

L'LLM seguirà questo flusso:
1. **Legge** automaticamente tutti i file di contesto + GDD
2. **Usa MCP** per leggere scene e script correlati
3. **Crea branch** `feature/player-movement` da `develop`
4. **Propone** Scene Tree diagram (ASCII) + lista file da creare
5. **Attende** il tuo OK ← ⚠️ Non scrive codice senza conferma
6. **Scrive** il codice rispettando le convenzioni GDScript
7. **Git diff** per verificare zero-regression
8. **Aggiorna** STATE.md, PROJECT_MAP.md, GDD.md e CHANGELOG.md
9. **Merge** su `develop`

### 3. Bug fix → `/fix`

Quando qualcosa si rompe:

```
/fix
Il player cade attraverso il pavimento quando si muove velocemente.
[incolla qui il log dell'errore se disponibile]
```

### 4. Pulizia → `/refactor`

Quando il codice diventa disordinato:

```
/refactor
Lo script PlayerController.gd è cresciuto troppo (350 righe). Decomponi in componenti.
```

### 5. Code Review → `/review`

Quando vuoi un'analisi del codice senza modifiche:

```
/review
Analizza la scena Player e tutti i suoi script figli.
```

L'LLM produrrà un report con: architettura, game feel, mobile compliance, performance, type safety, suggerimenti.

---

## 🔀 Git Branching Strategy

```
master          ← Produzione stabile (mai commit diretti)
  └─ develop    ← Integrazione sviluppo
       ├─ feature/player-movement
       ├─ feature/enemy-ai
       ├─ feature/audio-system
       └─ fix/collision-bug
```

### Regole
- **Nessun commit diretto su master** — solo merge da `develop` quando è stabile
- **Ogni modulo** (sistema di gioco, meccanica) = 1 branch `feature/`
- **Bug fix** = branch `fix/` da `develop`
- **Hotfix urgenti** = branch `hotfix/` da `master`, merge su master + develop
- **Commit atomici** con Conventional Commits: `feat(player): add movement component`

### Flusso
```
1. git checkout develop
2. git checkout -b feature/nome-sistema
3. [sviluppo con commit atomici]
4. git checkout develop
5. git merge feature/nome-sistema
6. git branch -d feature/nome-sistema
7. [quando develop è stabile]
8. git checkout master && git merge develop
```

---

## 🔄 Cosa Succede "Dietro le Quinte"

Ad ogni task, l'LLM aggiorna automaticamente questi file:

| File | Cosa viene aggiornato |
|---|---|
| `STATE.md` | Task completato, nuovi task, debiti tecnici |
| `PROJECT_MAP.md` | Nuove scene/autoloads/resources aggiunte |
| `CHANGELOG.md` | Entry con data e descrizione della modifica |
| `GDD.md` | Nuovi sistemi core aggiunti alla documentazione |

Questo significa che il progetto **si auto-documenta** durante la sessione di lavoro.

---

## 🛡 Protezioni Integrate

Il sistema include **guardrails** per evitare errori dell'LLM:

- ❌ Non inventa scene, script o addon inesistenti
- ❌ Non crea cartelle fuori dalla struttura definita
- ❌ Non scrive codice senza prima proporre un Scene Tree diagram
- ✅ Verifica che le scene e gli script esistano prima di importarli
- ✅ Chiede conferma in caso di dubbio
- ✅ Usa `git diff` per verificare zero-regression
- ✅ Usa MCP per leggere il progetto prima di modificarlo

---

## 📐 Regole che l'LLM Rispetta Automaticamente

Grazie a `.context/CONVENTIONS.md` e `.context/CONVENTIONS_GODOT.md`, il codice generato seguirà sempre:

- **Naming**: `snake_case` per variabili/funzioni, `PascalCase` per classi/nodi
- **Type hints**: Obbligatori su ogni variabile e funzione
- **Max 200 righe** per script — se supera, viene decomposto (Component Pattern)
- **Call down, signal up** — mai `get_parent().get_node()`
- **Data-driven** — dati in Custom Resources `.tres`, mai hardcodati
- **Mobile-ready** — touch input, target area 44dp, texture ≤ 2048px
- **Git**: Conventional Commits + branching model master/develop/feature
- **Niente debug**: zero `print()` nel codice finale

---

## 💡 Tips & Best Practices

### Sii specifico nelle richieste
```
❌ "Fammi il player"
✅ "Crea un CharacterBody2D player con joystick virtuale per mobile,
    sistema di health con 3 vite, e animazioni idle/run/jump."
```

### Incolla i log degli errori
```
❌ "Il player non si muove"
✅ "/fix
    Il player non risponde al touch input su Android.
    Log: ERROR: InputEventScreenTouch not handled in PlayerController.gd:45"
```

### Usa `/sync` se l'LLM sembra confuso
Se noti che l'LLM sta proponendo cose che non hanno senso nel contesto del gioco, usa `/sync` per riallinearlo.

### Controlla GDD.md periodicamente
È il tuo "game bible". Contiene il concept, le meccaniche, l'architettura e la roadmap. Tienilo aggiornato.

---

## 📁 Riferimento Rapido dei File

| File | Posizione | Funzione |
|---|---|---|
| `settings.json` | `.gemini/` | Auto-inject regole nell'LLM |
| `INSTRUCTIONS.md` | `.context/` | Ordine operativo + guardrails |
| `CONVENTIONS.md` | `.context/` | Regole di codifica + Git branching |
| `CONVENTIONS_GODOT.md` | `.context/` | Regole architetturali Godot 4 + Mobile |
| `PROMPTS.md` | `.context/` | Indice dei protocolli |
| `GDD.md` | `.antigravity/` | Game Design Document |
| `PROJECT_MAP.md` | `.antigravity/` | Mappa scene, autoloads, resources |
| `STATE.md` | `.antigravity/` | Stato avanzamento lavori |
| `TECH_STACK.md` | `.antigravity/` | Stack tecnologico + config mobile |
| `CHANGELOG.md` | `.antigravity/` | Log modifiche |
