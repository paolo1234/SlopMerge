# 📐 Convenzioni di Codifica (Godot 4 / GDScript)

> Regole universali da applicare a **qualsiasi** progetto Godot.
> La struttura specifica del progetto è definita in `.antigravity/PROJECT_MAP.md`.
> Le regole architetturali Godot-specifiche sono in `.context/CONVENTIONS_GODOT.md`.

---

## 📛 Naming Conventions (GDScript)

| Elemento | Stile | Esempio |
|---|---|---|
| Variabili e funzioni | `snake_case` | `get_player_data`, `is_attacking` |
| Classi e Nodi | `PascalCase` | `PlayerController`, `EnemySpawner` |
| File script `.gd` | `PascalCase` | `PlayerController.gd`, `EventBus.gd` |
| File scene `.tscn` | `PascalCase` | `MainMenu.tscn`, `GameWorld.tscn` |
| File risorsa `.tres` | `PascalCase` | `EnemyStats.tres`, `WaveConfig.tres` |
| Cartelle | `snake_case` | `player/`, `enemy_types/`, `ui_screens/` |
| Costanti | `UPPER_SNAKE_CASE` | `MAX_HEALTH`, `SPAWN_INTERVAL` |
| Segnali | `snake_case` (passato) | `health_changed`, `enemy_died` |
| Enums | `PascalCase` (tipo) + `UPPER_SNAKE_CASE` (valori) | `enum State { IDLE, RUNNING, JUMPING }` |

---

## 📂 Struttura Cartelle Godot

> La struttura specifica varia per tipo di gioco. Qui i principi universali.

### Regole Generali
- **Feature-based**: raggruppare il codice per sistema di gioco, non per tipo di file.
- **Isolamento**: ogni sistema (player, enemy, UI) deve essere auto-contenuto.
- **Shared**: il codice condiviso tra sistemi va nella cartella `autoloads/` o `common/`.
- **Colocation**: script `.gd` e scene `.tscn` dello stesso sistema nella stessa cartella.
- **Resources**: tutte le risorse `.tres` (dati, configurazioni) in `resources/`.

### Struttura Base Godot
```
res://
├── scenes/                 # Scene .tscn divise per sistema
│   ├── player/             # Player e componenti
│   ├── enemies/            # Nemici e AI
│   ├── ui/                 # Interfacce utente
│   ├── levels/             # Livelli e mondi
│   └── main/               # Scene principali (Main, GameOver, etc.)
├── scripts/                # Script condivisi (se non colocati)
├── resources/              # .tres Custom Resources (dati, config)
├── autoloads/              # Singleton (EventBus, GameManager, SaveSystem)
├── assets/                 # Risorse grafiche, audio, font
│   ├── sprites/
│   ├── audio/
│   ├── fonts/
│   └── shaders/
├── addons/                 # Plugin Godot
└── export/                 # Configurazioni export (Android, iOS)
```

---

## 📏 Regola dei 200

- Se uno script supera le **200 righe**, deve essere decomposto.
- Estrarre la logica di business in componenti figli o script separati.
- Mantenere ogni script con **singola responsabilità** (Component Pattern).

---

## 🧹 Qualità del Codice

- **Nessun log di debug** nel codice finale (`print()`, `push_warning()` di debug).
- **Type hints obbligatori** — ogni variabile e funzione DEVE avere type hints espliciti.
- **Nessun magic number** — usare costanti con nome descrittivo.
- **Commenti**: solo per spiegare il *perché*, mai il *cosa* (il codice deve essere autoesplicativo).
- **Funzioni pure** dove possibile — nessun side effect nascosto.
- **DRY** — Non ripetere logica. Se qualcosa serve in più punti, estrailo in un componente o autoload.

---

## ⚠️ Error Handling (GDScript)

- **Verificare** i valori null/invalid prima di usarli con `if` guard clauses.
- **Usare** `push_error()` per errori critici, `push_warning()` per problemi non fatali.
- **Mai silenziare** errori — ogni condizione anomala deve essere gestita.
- **Fallback** — prevedere sempre un comportamento di default in caso di errore.
- **Assert** — usare `assert()` in debug per validare precondizioni.

---

## 🚫 Antipattern — Cosa NON Fare

> Esempi concreti di errori comuni. L'LLM deve evitare questi pattern.

### ❌ Script monolitico (God Script)
```gdscript
# SBAGLIATO — un solo script gestisce movement, health, attack, inventory
# PlayerController.gd con 500+ righe

# CORRETTO — Component Pattern
# PlayerController.gd → compone i figli
# HealthComponent.gd → gestione vita
# MovementComponent.gd → gestione movimento
# AttackComponent.gd → gestione attacco
```

### ❌ get_parent() e path hardcoded
```gdscript
# SBAGLIATO — accoppiamento forte
var player = get_parent().get_node("Player")

# CORRETTO — signal up, call down
signal damage_taken(amount: int)
# oppure
@export var target_path: NodePath
@onready var target: Node = get_node(target_path)
```

### ❌ Dati hardcodati negli script
```gdscript
# SBAGLIATO — magic numbers
var speed: float = 300.0
var max_health: int = 100

# CORRETTO — Custom Resource
@export var stats: CharacterStats  # .tres con tutti i dati
```

### ❌ Allocazioni in _process
```gdscript
# SBAGLIATO — allocazione ogni frame
func _process(delta: float) -> void:
    var new_vec = Vector2(randf(), randf())  # GC pressure

# CORRETTO — cache e riuso
var _cached_vec: Vector2 = Vector2.ZERO
func _process(delta: float) -> void:
    _cached_vec.x = randf()
    _cached_vec.y = randf()
```

---

## 🔀 Convenzioni Git

### Branching Model

```
BRANCHING MODEL:
─────────────────────────────────────────
master          ← Produzione stabile (protetto, mai commit diretti)
  └─ develop    ← Integrazione sviluppo
       ├─ feature/player-movement
       ├─ feature/enemy-ai
       ├─ feature/audio-system
       └─ fix/collision-bug

REGOLE:
• Nessun commit diretto su master
• Ogni modulo (sistema, meccanica) = 1 branch feature/
• Merge su develop via merge commit descrittivo
• Merge su master solo quando develop è stabile e testato
• Hotfix: branch hotfix/ da master, merge su master + develop
```

### Commit Messages (Conventional Commits)
```
type(scope): descrizione breve

Corpo opzionale per dettagli aggiuntivi.
```

| Tipo | Uso |
|---|---|
| `feat` | Nuova meccanica, sistema, scena |
| `fix` | Bug fix |
| `refactor` | Refactoring (nessun cambio funzionale) |
| `docs` | Documentazione (GDD, commenti) |
| `style` | Formattazione (nessun cambio logico) |
| `test` | Aggiunta o modifica test (GUT) |
| `chore` | Manutenzione, config, export settings |
| `asset` | Aggiunta/modifica asset grafici o audio |

### Branch Naming
- `feature/nome-sistema` — nuova meccanica o sistema di gioco
- `fix/nome-bug` — correzione bug
- `refactor/descrizione` — ristrutturazione codice/scene
- `hotfix/descrizione` — fix urgente su master

### Workflow Git per Feature
```
1. git checkout develop
2. git checkout -b feature/nome-sistema
3. [sviluppo e commit atomici]
4. git checkout develop
5. git merge feature/nome-sistema
6. [test e verifica su develop]
7. git branch -d feature/nome-sistema
8. [quando develop è stabile] git checkout master && git merge develop
```

---

## 🧪 Testabilità

- Scrivere funzioni **piccole e testabili** (single responsibility).
- Separare la logica di business dai nodi di scena per facilitare il testing con GUT.
- Usare Custom Resources (`.tres`) per iniettare dati testabili.
- Nominare i test in modo descrittivo: `test_should_[expected]_when_[condition]`.

---

## 🚀 Versioning & Deployment (Android)

### Schema Versione: Semantic Versioning
```
MAJOR.MINOR.PATCH
  │      │     └── Bug fix, hotfix
  │      └── Nuova feature, contenuto
  └── Cambio architetturale, breaking change
```
Esempio: `1.7.2` → `1.8.0` (nuova feature) → `2.0.0` (refactor totale)

### File che gestiscono la versione

| File | Campo | Descrizione |
|------|-------|-------------|
| `project.godot` | `application/config/version` | Versione visualizzata nel gioco |
| `export_presets.cfg` | `version/code` | Codice numerico Android (incrementa +1 ad ogni release) |
| `export_presets.cfg` | `version/name` | Stringa versione nel manifest Android |
| `version.json` (remoto) | `latest_version` | Versione più recente disponibile per download |

### Checklist Pre-Release (OBBLIGATORIA)
```
1. [ ] Aggiorna `application/config/version` in project.godot
2. [ ] Incrementa `version/code` (+1) e `version/name` in export_presets.cfg
3. [ ] Esporta l'APK da Godot Editor
4. [ ] Upload APK su GitHub Releases (tag: v1.X.X)
5. [ ] Aggiorna `version.json` nella root del repo:
       - `latest_version` = nuova versione
       - `direct_apk` = URL diretto al download dell'APK
       - `changelog` = breve descrizione novità
6. [ ] Commit e push `version.json` su main/develop
7. [ ] Verifica: installa l'APK vecchio → il bottone Update deve apparire
```

### Formato `version.json`
```json
{
  "latest_version": "1.8.0",
  "direct_apk": "https://github.com/USER/REPO/releases/download/v1.8.0/SlopMerge.apk",
  "changelog": "Nuovo sistema di aggiornamento in-app"
}
```

> [!IMPORTANT]
> Il campo `direct_apk` deve essere un **link diretto** al file `.apk`, non una pagina HTML.
> Per GitHub Releases: `https://github.com/USER/REPO/releases/download/TAG/FILENAME.apk`

### Deploy Rapido (Workflow)
```
1. Esporta APK → salva in /builds/SlopMerge.apk
2. Crea GitHub Release con tag vX.Y.Z, allega APK
3. Copia URL diretto dell'APK
4. Aggiorna version.json con la nuova versione e URL
5. git add version.json && git commit -m "chore: bump version vX.Y.Z"
6. git push
```

