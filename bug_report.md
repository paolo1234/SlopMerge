# Bug Report - Slop Merge

## Summary of Findings
Static analysis and logic review identified a few potential glitches, mostly related to state management during transitions and execution order. No critical "crash-on-start" bugs were found in the current v1.8.4 branch.

---

## High Priority
*None identified.*

---

## Medium Priority

### 1. TransitionManager Overlap Glitch [RESOLVED]
- **Fix**: Added `is_transitioning` boolean guard.

### 2. VFX/Fruit Spawn Order [RESOLVED]
- **Fix**: Reordered logic to call `add_child()` before setting `global_position`.

---

## Low Priority

### 3. Unused Signal Warnings (Maintenance) [RESOLVED]
- **Fix**: Added `@warning_ignore("unused_signal")` to `EventBus.gd`.

### 4. NextQueue Slot Inconsistency
- **Description**: The `TextureRect` slots in the HUD have varying sizes (80, 60, 40). While the aspect ratio is maintained, very wide or tall custom fruits might appear significantly smaller than expected in the 40px slot.
- **Impact**: Minor visual inconsistency.
- **Suggested Fix**: Standardize slot sizes or use a more dynamic scaling approach.

### 5. CringeLine Edge Trigger
- **Description**: If a fruit is spawned exactly at the boundary of the `CringeLine`, it might trigger the warning timer prematurely.
- **Impact**: Annoying "Danger" beep when launching.
- **Suggested Fix**: Ensure the Spawner position has a 10-20px buffer below the `CringeLine`.

---

## Next Steps
1. Implement the `is_transitioning` guard in `TransitionManager`.
2. Reorder the spawning logic in `GameManager`.
3. (Optional) Clean up `EventBus` warnings.
