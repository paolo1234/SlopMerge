extends Node2D

@onready var fruits_container: Node2D = $FruitsContainer

func _ready() -> void:
	# Registra il container nel GameManager per ottimizzare le ricerche
	var gm = get_node("/root/GameManager")
	gm.fruits_container = fruits_container
	gm.score = 0 # Reset score per la nuova partita
