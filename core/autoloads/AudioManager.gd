extends Node

var sounds = {}

func _ready() -> void:
	# Carichiamo i suoni solo se esistono
	var sound_paths = {
		"merge": "res://assets/audio/merge.wav",
		"launch": "res://assets/audio/launch.wav",
		"spawn": "res://assets/audio/spawn.wav",
		"laser": "res://assets/audio/laser.wav"
	}
	
	for key in sound_paths:
		if ResourceLoader.exists(sound_paths[key]):
			sounds[key] = load(sound_paths[key])
	
	# Creiamo un pool di AudioStreamPlayer
	for i in range(10):
		var player = AudioStreamPlayer.new()
		player.name = "AudioPlayer_" + str(i)
		add_child(player)

func play_sound(sound_name: String) -> void:
	if not sounds.has(sound_name):
		return
		
	var stream = sounds[sound_name]
	if not stream:
		return
		
	# Trova il primo player non occupato
	for player in get_children():
		if player is AudioStreamPlayer and not player.playing:
			player.stream = stream
			player.play()
			return

func set_master_volume(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(bus_idx, value <= 0.0)

func set_sfx_volume(value: float) -> void:
	# Se abbiamo un bus SFX separato, usalo. Altrimenti crealo o usa Master.
	# Per ora assumiamo che l'utente voglia controllare il volume dei suoni giocati qui.
	# Possiamo aggiungere un bus "SFX" nel Bus Layout se necessario.
	var bus_idx = AudioServer.get_bus_index("SFX")
	if bus_idx == -1:
		# Fallback su Master se SFX non esiste
		set_master_volume(value)
	else:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
		AudioServer.set_bus_mute(bus_idx, value <= 0.0)

func get_master_volume() -> float:
	var bus_idx = AudioServer.get_bus_index("Master")
	return db_to_linear(AudioServer.get_bus_volume_db(bus_idx))

func get_sfx_volume() -> float:
	var bus_idx = AudioServer.get_bus_index("SFX")
	if bus_idx == -1: return get_master_volume()
	return db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
