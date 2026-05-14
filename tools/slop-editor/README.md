# 🎨 SlopEditor — Manuale d'Uso

Editor web per la gestione degli spritesheet del gioco **Slop Merge**.

## 🚀 Come Aprire

Apri il file `index.html` direttamente nel browser (doppio click).
**Non serve un server** — funziona con `file://`.

---

## 🔁 Workflow per Slop Merge

### 1. Apri il progetto esistente
1. Clicca **📂 Open** → seleziona `projects/slop_merge_spritesheet.json`
2. Clicca **🖼 Load Image** → seleziona `../../assets/sprites/slop_merge_spritesheet.png`
3. La griglia 4×4 si sovrappone automaticamente allo spritesheet

### 2. Naviga lo spritesheet
- **Scroll** = zoom in/out
- **Alt + Drag** o **Middle Mouse** = pan/sposta
- **Click su cella** = seleziona un frutto → l'Inspector a destra mostra le proprietà

### 3. Ispeziona/Modifica uno Sprite
- Clicca una cella nel canvas
- Nel pannello **Inspector** (destra) vedrai:
  - `Name`, `Region Rect`, `Pivot`, `Tags`
- Modifica il nome e clicca **💾 Save Sprite**

### 4. Crea un'Animazione
1. Clicca **＋** nella sezione "ANIMATIONS" (sinistra)
2. Dai un nome es. `idle_pisello`
3. Seleziona una cella nel canvas (es. la prima face del Pisello)
4. Clicca **＋ Add to Animation** nell'Inspector → seleziona `idle_pisello`
5. Ripeti per ogni frame dell'animazione (sub_index diverso)
6. Nella **Timeline** (basso), clicca ▶ per vedere la preview

### 5. Esporta per Godot
Clicca **⬆ Export** e scegli il formato:

| Tab | Output | Usa quando |
|-----|--------|------------|
| **JSON Project** | File `.json` dell'editor | Per riaprire il progetto |
| **Godot .tres**  | Risorsa `SpriteSheetLayout` | Per usare in Godot |
| **GDScript**     | Costanti + helper pronti | Per copincollare in uno script |

### 6. Usa il `.tres` in Godot
1. Copia il file `.tres` scaricato in `resources/layouts/`
2. In `GameManager.gd`, cambia la riga:
   ```gdscript
   var active_layout: Resource = preload("res://resources/layouts/default_spritesheet.tres")
   ```
   Con il tuo nuovo file.
3. **Tutti i frutti e le UI si aggiornano automaticamente** — zero altre modifiche!

---

## ⌨️ Shortcut Tastiera

| Shortcut | Azione |
|----------|--------|
| `Ctrl+S` | Salva progetto (.json) |
| `Ctrl+O` | Apri progetto |
| `Ctrl+E` | Apri modal Export |
| `Escape` | Chiudi modal |
| `Scroll` | Zoom canvas |
| `Alt+Drag` | Pan canvas |

---

## 📁 Struttura Files

```
tools/slop-editor/
├── index.html           ← Apri questo nel browser
├── style.css            ← Tema dark
├── app.js               ← Controller principale
├── modules/
│   ├── canvas.js        ← Renderer canvas con zoom/pan/griglia
│   ├── inspector.js     ← Pannello proprietà
│   ├── timeline.js      ← Timeline animazioni
│   └── exporter.js      ← Export JSON / .tres / .gd
└── projects/
    └── slop_merge_spritesheet.json  ← Progetto pre-caricato con tutti gli 11 frutti
```
