---
description: Raffinamento di una funzionalità esistente e bug fixing — Protocollo 7
---

# 🚀 Upgrade & Refine Flow (Protocollo 7)

Questo workflow serve per migliorare, ottimizzare o correggere una funzionalità già esistente.

// turbo-all

## Steps

1. **Sincronizzazione**: Esegui `/sync` per allineare il contesto.
2. **Analisi Critica**: Analizza la feature esistente (codice, scene, risorse).
3. **Pianificazione Miglioramento**:
   - Ottimizzazione Performance.
   - Miglioramento Game Feel (Juice).
   - Pulizia Codice (Refactoring).
   - **Attendi conferma.**
4. **Git Branching**: Crea un nuovo branch `upgrade/nome-feature` da `develop`.
5. **Implementazione**: Applica le modifiche mantenendo la compatibilità con il resto del sistema.
6. **Validazione & Test**: 
   - Esegui `git diff`.
   - **Avvia il gioco** e verifica che il miglioramento sia effettivo.
7. **Commit Atomico**: `git add . && git commit -m "upgrade(scope): migliorata [feature] e risolti bug X, Y"`.
8. **Documentazione (SYNC)**:
   - Aggiorna `.antigravity/STATE.md`.
   - Aggiorna `TASK.md` nella root.
   - Aggiungi entry in `.antigravity/CHANGELOG.md`.
9. **Merge**: Ritorna su `develop` e unisci il branch.
