---
description: Raffinamento di una funzionalità esistente e bug fixing — Protocollo 7
---

# 🚀 Upgrade & Refine Flow (Protocollo 7)

Questo workflow serve per migliorare, ottimizzare o correggere una funzionalità già esistente.

// turbo-all

## Steps

1. **Analisi Critica**: Analizza la feature esistente (codice, scene, risorse).
2. **Bug Hunting**: Identifica eventuali bug o colli di bottiglia durante l'analisi.
3. **Pianificazione Miglioramento**:
   - Ottimizzazione Performance.
   - Miglioramento Game Feel (Juice).
   - Pulizia Codice (Refactoring).
4. **Crea branch Git**: `upgrade/nome-feature` da `develop`.
5. **Implementazione**: Applica le modifiche mantenendo la compatibilità con il resto del sistema.
6. **Validazione**: Esegui il gioco e verifica che il miglioramento sia effettivo e non abbia introdotto regressioni.
7. **Commit**: `git add . && git commit -m "upgrade(scope): migliorata [feature] e risolti bug X, Y"`.
8. **Documentazione**: Aggiorna `STATE.md` e `CHANGELOG.md`.
9. **Merge**: Ritorna su `develop` e unisci il branch.
