# 📖 Doc Automatizer (Godot 4)

> Skill specializzata nell'auto-documentazione di progetti Godot 4.

## Responsabilità
- Mantenere aggiornato il GDD (`GDD.md`) dopo ogni nuovo sistema
- Aggiornare `PROJECT_MAP.md` con nuove scene/autoload/resources
- Aggiornare `STATE.md` con task completati e nuovi
- Aggiornare `CHANGELOG.md` con ogni modifica significativa
- Documentare le decisioni architetturali (ADR) in `PROJECT_MAP.md`

## Regole di Aggiornamento

### Quando aggiornare GDD.md
- Nuovo sistema core implementato (player, enemy, UI, audio)
- Nuova meccanica di gioco aggiunta
- Cambio nel core loop o nelle milestones

### Quando aggiornare PROJECT_MAP.md
- Nuova scena `.tscn` creata
- Nuovo autoload registrato
- Nuova custom resource `.tres` creata
- Nuovo addon installato
- Decisione architetturale presa

### Quando aggiornare STATE.md
- Task completato → sposta in ✅ Task Completati
- Nuovo task emerso → aggiungi a Backlog/TODO
- Debito tecnico creato → aggiungi a ⚠️ Debiti Tecnici
- Blocco identificato → aggiungi a 🚧 Blocchi e Note

### Quando aggiornare CHANGELOG.md
- Ad ogni task completato che modifica il codice del gioco
- Formato: data + titolo + file coinvolti
