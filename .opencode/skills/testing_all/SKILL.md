---
name: testing_all
description: "Test completo di tutte le feature del gioco (Godot Native)"
---

# 🧪 Testing All Flow (Godot)

Questo workflow esegue un test esaustivo di tutto il gioco tramite Godot MCP.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Check-list Funzionalità**: Genera una lista di feature critiche da testare basandoti su `.antigravity/STATE.md`.
3. **Smoke Test Engine**:
   - Avvia il progetto (`mcp_godot_run_project`).
   - Usa `mcp_godot_game_get_scene_tree` per verificare che la scena iniziale sia corretta.
   - Verifica i log via `mcp_godot_get_debug_output`.
4. **Validazione Gameplay**:
   - Simula eventi (lanci, fusioni) tramite `mcp_godot_game_eval`.
   - Verifica transizioni di scena (Menu -> Game -> GameOver).
5. **Verifica Asset & UI**:
   - Scatta screenshot delle UI principali (`mcp_godot_game_screenshot`).
   - Controlla che non ci siano leak di memoria significativi.
6. **Report di Validazione**: Crea un artifact `test_report.md` con l'esito per ogni feature (PASS/FAIL).
7. **Fix/Checkpoint**: Se trovi bug gravi usa `/fix`, altrimenti salva con `/checkpoint`.