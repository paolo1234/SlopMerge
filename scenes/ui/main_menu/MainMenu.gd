extends Control

const UPDATE_OVERLAY_SCENE = preload("res://scenes/ui/update_overlay/update_overlay.tscn")
var _update_tween: Tween

func _ready() -> void:
	_connect_button_signals()
	_setup_update_button()
	_add_version_label()
	_setup_juice()

	UIUtils.animate_pop_in($Title)
	UIUtils.animate_pop_in($VBoxContainer, 0.2)

	if UpdateManager.is_update_available:
		_show_update_button()
	else:
		UpdateManager.update_available.connect(_on_update_available)

func _connect_button_signals() -> void:
	var vbox: VBoxContainer = $VBoxContainer
	var buttons := [
		["PlayButton", _on_play_pressed],
		["GachaButton", _on_gacha_pressed],
		["SlopdexButton", _on_slopdex_pressed],
		["WardrobeButton", _on_wardrobe_pressed],
		["QuitButton", _on_quit_pressed]
	]
	for btn_data in buttons:
		var btn: Button = vbox.get_node(btn_data[0])
		if not btn.pressed.is_connected(btn_data[1]):
			btn.pressed.connect(btn_data[1])

func _setup_update_button() -> void:
	var update_btn: Button = $VBoxContainer/UpdateButton
	update_btn.visible = false
	if not update_btn.pressed.is_connected(_on_update_pressed):
		update_btn.pressed.connect(_on_update_pressed)

func _add_version_label() -> void:
	var v_label: Label = $VersionLabel if has_node("VersionLabel") else Label.new()
	var version := UpdateManager.latest_version
	if version == "":
		version = ProjectSettings.get_setting("application/config/version", "0.0.0")
	v_label.text = "v" + version
	v_label.modulate = Color(1, 1, 1, 0.4)
	v_label.set("theme_override_font_sizes/font_size", 24)
	
	if v_label.get_parent() == null:
		add_child(v_label)
	v_label.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	v_label.offset_bottom = -20
	v_label.offset_right = -20
	v_label.grow_horizontal = Control.GROW_DIRECTION_BEGIN
	v_label.grow_vertical = Control.GROW_DIRECTION_BEGIN

func _on_update_available(_version: String, _changelog: String) -> void:
	_show_update_button()

func _show_update_button() -> void:
	var update_btn: Button = $VBoxContainer/UpdateButton
	update_btn.visible = true
	update_btn.text = "🚀 UPDATE v%s 🚀" % UpdateManager.latest_version

	# Pulsazione per farsi notare
	if _update_tween:
		_update_tween.kill()
	_update_tween = create_tween().set_loops()
	_update_tween.tween_property(update_btn, "modulate", Color(1, 0.5, 0.5), 0.8)
	_update_tween.tween_property(update_btn, "modulate", Color.WHITE, 0.8)

func _on_update_pressed() -> void:
	# Crea e mostra l'overlay modulare
	var overlay = UPDATE_OVERLAY_SCENE.instantiate()
	add_child(overlay)
	UpdateManager.start_download()

## ─── JUICE & NAVIGATION ─────────────────────────────────────

func _setup_juice() -> void:
	# Pulse title
	var tween := create_tween().set_loops()
	tween.tween_property($Title, "scale", Vector2(1.05, 1.05), 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Title, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE)
	$Title.pivot_offset = $Title.size / 2

	# Standardize all buttons
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			UIUtils.setup_button(btn)

func _on_play_pressed() -> void:
	print("[MainMenu] Play pressed")
	TransitionManager.transition_to("res://scenes/levels/main/main.tscn")

func _on_gacha_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/gacha/gacha.tscn")

func _on_slopdex_pressed() -> void:
	print("[MainMenu] Slopdex pressed")
	TransitionManager.transition_to("res://scenes/ui/slopdex/slopdex.tscn")

func _on_wardrobe_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/wardrobe/wardrobe.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
