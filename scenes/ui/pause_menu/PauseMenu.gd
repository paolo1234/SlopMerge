extends CanvasLayer

@onready var blur_bg: ColorRect = $Control/BlurBG
@onready var center_panel: Panel = $Control/CenterPanel
@onready var master_slider: HSlider = %MasterSlider
@onready var sfx_slider: HSlider = %SFXSlider

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Sincronizza slider con AudioManager
	if has_node("/root/AudioManager"):
		var am = get_node("/root/AudioManager")
		master_slider.value = am.get_master_volume()
		sfx_slider.value = am.get_sfx_volume()
	
	# Animazione d'ingresso
	UIUtils.animate_pop_in(center_panel)
	
	# Setup buttons
	UIUtils.setup_button($Control/CenterPanel/VBoxContainer/ResumeButton)
	UIUtils.setup_button($Control/CenterPanel/VBoxContainer/MainMenuButton)
	
	# Pausa il gioco
	get_tree().paused = true

func _on_resume_pressed() -> void:
	AudioManager.play_ui_sound("click")
	
	var tween = create_tween().set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(center_panel, "scale", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	
	get_tree().paused = false
	queue_free()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	if has_node("/root/TransitionManager"):
		get_node("/root/TransitionManager").transition_to("res://scenes/ui/main_menu/main_menu.tscn")
	else:
		get_tree().change_scene_to_file("res://scenes/ui/main_menu/main_menu.tscn")
	queue_free()

func _on_master_slider_value_changed(value: float) -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").set_master_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	if has_node("/root/AudioManager"):
		get_node("/root/AudioManager").set_sfx_volume(value)
