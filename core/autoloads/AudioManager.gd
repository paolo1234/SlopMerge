extends Node

## AudioManager: Robust sound system with pooling and volume management.
## Optimized for high-frequency sounds like merges and UI clicks.

# Audio Bus Names
const BUS_MASTER = "Master"
const BUS_SFX = "SFX"
const BUS_MUSIC = "Music"

# Sound Library
var sounds: Dictionary = {}
var player_pool: Array[AudioStreamPlayer] = []
var pool_size: int = 12

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_initialize_sounds()
	_initialize_pool()

func _initialize_sounds() -> void:
	var sound_map = {
		"merge": "res://assets/audio/merge.wav",
		"launch": "res://assets/audio/launch.wav",
		"spawn": "res://assets/audio/spawn.wav",
		"laser": "res://assets/audio/laser.wav",
		"hover": "res://assets/audio/ui_hover.wav",
		"click": "res://assets/audio/ui_click.wav",
		"game_over": "res://assets/audio/game_over.wav"
	}
	
	for key in sound_map:
		if ResourceLoader.exists(sound_map[key]):
			sounds[key] = load(sound_map[key])
		else:
			push_warning("[AudioManager] Missing sound file: ", sound_map[key])

func _initialize_pool() -> void:
	for i in range(pool_size):
		var player = AudioStreamPlayer.new()
		player.bus = BUS_SFX
		add_child(player)
		player_pool.append(player)

func play_sound(sound_name: String, pitch: float = 1.0, volume_db: float = 0.0) -> void:
	if not sounds.has(sound_name): return
	var stream = sounds[sound_name]
	if not stream: return
	
	var player = _get_available_player()
	if player:
		player.stream = stream
		player.pitch_scale = pitch * randf_range(0.95, 1.05)
		player.volume_db = volume_db
		player.play()

func play_ui_sound(sound_name: String) -> void:
	# UI sounds usually have fixed pitch for better consistency
	play_sound(sound_name, 1.0, -5.0)

func play_tiered_sound(tier: int) -> void:
	# Tiered logic: heavier sounds and lower pitch for larger fruits
	var base_pitch = 1.2 - (tier * 0.05)
	var volume_boost = clamp(tier * 0.5, 0.0, 6.0)
	
	play_sound("merge", base_pitch, volume_boost)

func _get_available_player() -> AudioStreamPlayer:
	for player in player_pool:
		if not player.playing:
			return player
	# If all busy, steal the oldest one (first in list)
	var oldest = player_pool.pop_front()
	player_pool.append(oldest)
	return oldest

# Volume Controls
func set_volume(bus_name: String, linear_value: float) -> void:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(linear_value))
		AudioServer.set_bus_mute(bus_idx, linear_value <= 0.001)

func get_volume(bus_name: String) -> float:
	var bus_idx = AudioServer.get_bus_index(bus_name)
	if bus_idx != -1:
		return db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	return 1.0

func set_master_volume(linear_value: float) -> void:
	set_volume(BUS_MASTER, linear_value)

func get_master_volume() -> float:
	return get_volume(BUS_MASTER)

func set_sfx_volume(linear_value: float) -> void:
	set_volume(BUS_SFX, linear_value)

func get_sfx_volume() -> float:
	return get_volume(BUS_SFX)

func set_music_volume(linear_value: float) -> void:
	set_volume(BUS_MUSIC, linear_value)

func get_music_volume() -> float:
	return get_volume(BUS_MUSIC)
