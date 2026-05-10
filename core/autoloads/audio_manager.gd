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
		if FileAccess.file_exists(sound_paths[key]):
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
		if not player.playing:
			player.stream = stream
			player.play()
			return
