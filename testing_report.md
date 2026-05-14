# Testing Report - v1.8.4 Fixes

## Test Objectives
- Verify Spawner Y-position relative to CringeLine and HUD.
- Confirm NextQueue excludes the "in-hand" fruit.
- Validate `TransitionManager` guard against multiple calls.
- Check for regression in fruit merging logic after spawning order fix.

---

## Results

### 1. Spawner & HUD Layout
- **Observation**: Spawner correctly positioned at `size.y - 340`.
- **Status**: ✅ **PASSED**
- **Detail**: Visual inspection confirms a safe buffer below the red CringeLine and above the bottom HUD.

### 2. NextQueue Logic
- **Observation**: Hand fruit is "Pisello Triste"; first slot in `NextQueue` is "Limone Arrabbiato".
- **Status**: ✅ **PASSED**
- **Detail**: The `slice(0, 3)` logic correctly isolates upcoming fruits.

### 3. Transition Guard
- **Observation**: Calling `transition_to` twice via console returned `true` for the first call and did not trigger a crash or visual stutter.
- **Status**: ✅ **PASSED**
- **Detail**: The `is_transitioning` flag effectively blocks concurrent scene changes.

### 4. Spawning Logic & Merge
- **Observation**: Merged fruits are initialized at (0,0) in `_ready` but immediately moved to the correct `pos` after `add_child`.
- **Status**: ✅ **PASSED**
- **Detail**: Physics engine correctly processes the merge at the calculated midpoint.

### 5. Debug Logs
- **Observation**: `get_errors` returned 0 warnings/errors.
- **Status**: ✅ **PASSED**
- **Detail**: `@warning_ignore` successfully cleaned up the noise in `EventBus`.

---

## Conclusion
The fixes are stable and have no visible side effects on core gameplay. v1.8.4 is verified for distribution.
