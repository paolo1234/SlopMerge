---
name: testing
description: "Test mirato di una feature specifica o dell'ultima lavorata (Godot Native)"
---

# 🎯 Targeted Testing Flow (Godot)

Questo workflow testa una singola feature utilizzando gli strumenti di Godot MCP.

// turbo-all

## Steps

1. **Identificazione**: Se l'utente non specifica una feature, identifica l'ultima lavorata consultando `.antigravity/CHANGELOG.md`.
2. **Analisi Feature**: Leggi il codice relativo alla feature per identificare potenziali punti di rottura (edge cases).
3. **Setup Test (Headless/Live)**:
   - Prepara il gioco per testare la specifica feature.
   - Usa `mcp_godot_game_eval` per manipolare lo stato se il gioco è già in esecuzione.
4. **Esecuzione Test**:
   - Avvia il progetto con `mcp_godot_run_project`.
   - Usa `mcp_godot_game_screenshot` per verificare lo stato visivo della UI/Gameplay.
   - Monitora `mcp_godot_get_debug_output` per intercettare errori o avvisi.
5. **Verifica Side-Effects**: Assicurati che componenti correlate non siano rotte.
6. **Report**: Riporta l'esito del test con screenshot allegati (path locale). Se fallisce, avvia `/fix`.