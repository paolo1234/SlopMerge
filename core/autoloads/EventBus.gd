extends Node

# Global Signals for Decoupled Communication
signal score_changed(new_score: int)
signal combo_changed(new_combo: int)
signal game_over
signal merge_occurred(pos: Vector2, tier: int)
signal chain_event(pos: Vector2, combo: int, bonus: float)
signal special_ability_triggered(type: String, amount: int)
signal cringe_warning(active: bool, progress: float)

# Juice & Metagame
signal screen_shake_requested(intensity: float)
signal brainrot_meter_updated(value: float)
signal brainrot_ready
