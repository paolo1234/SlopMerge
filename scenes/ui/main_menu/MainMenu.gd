extends Control

## ─── Download Overlay (creato via codice) ────────────────────
var _overlay: PanelContainer
var _progress_bar: ProgressBar
var _status_label: Label
var _cancel_button: Button
var _update_tween: Tween

func _ready() -> void:
	# I segnali pressed dei bottoni menu sono già connessi nel .tscn

	# Update button — nascosto di default
	var update_btn: Button = $VBoxContainer/UpdateButton
	update_btn.visible = false
	if not update_btn.pressed.is_connected(_on_update_pressed):
		update_btn.pressed.connect(_on_update_pressed)

	# Connetti segnali UpdateManager
	if UpdateManager.is_update_available:
		_show_update_button()
	else:
		UpdateManager.update_available.connect(_on_update_available)

	UpdateManager.download_progress.connect(_on_download_progress)
	UpdateManager.download_completed.connect(_on_download_completed)
	UpdateManager.download_failed.connect(_on_download_failed)

	_setup_juice()
	_create_download_overlay()

## ─── UPDATE BUTTON ───────────────────────────────────────────

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
	_show_download_overlay()
	UpdateManager.start_download()

## ─── DOWNLOAD OVERLAY ────────────────────────────────────────

func _create_download_overlay() -> void:
	# Dimming background
	var dimmer := ColorRect.new()
	dimmer.name = "OverlayDimmer"
	dimmer.color = Color(0, 0, 0, 0.7)
	dimmer.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	dimmer.mouse_filter = Control.MOUSE_FILTER_STOP
	dimmer.visible = false
	add_child(dimmer)

	# Panel container
	_overlay = PanelContainer.new()
	_overlay.name = "DownloadOverlay"
	_overlay.visible = false
	_overlay.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	_overlay.custom_minimum_size = Vector2(800, 400)
	_overlay.anchor_left = 0.5
	_overlay.anchor_right = 0.5
	_overlay.anchor_top = 0.5
	_overlay.anchor_bottom = 0.5
	_overlay.offset_left = -400
	_overlay.offset_right = 400
	_overlay.offset_top = -200
	_overlay.offset_bottom = 200

	# Stile panel
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.12, 0.12, 0.16, 0.95)
	style.border_color = Color(0.4, 0.2, 0.8, 1.0)
	style.set_border_width_all(3)
	style.set_corner_radius_all(20)
	style.set_content_margin_all(40)
	_overlay.add_theme_stylebox_override("panel", style)
	add_child(_overlay)

	# VBox interno
	var vbox := VBoxContainer.new()
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	_overlay.add_child(vbox)

	# Titolo
	var title := Label.new()
	title.text = "📥 DOWNLOADING UPDATE..."
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var title_settings := LabelSettings.new()
	title_settings.font_size = 42
	title_settings.font_color = Color(1.0, 0.85, 0.0)
	title_settings.outline_size = 6
	title_settings.outline_color = Color(0.0, 0.0, 0.0)
	title.label_settings = title_settings
	vbox.add_child(title)

	# Progress bar
	_progress_bar = ProgressBar.new()
	_progress_bar.custom_minimum_size = Vector2(0, 50)
	_progress_bar.min_value = 0.0
	_progress_bar.max_value = 100.0
	_progress_bar.value = 0.0
	_progress_bar.show_percentage = false

	# Stile progress bar
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.2, 0.2, 0.25, 1.0)
	bg_style.set_corner_radius_all(12)
	_progress_bar.add_theme_stylebox_override("background", bg_style)

	var fill_style := StyleBoxFlat.new()
	fill_style.bg_color = Color(0.4, 0.2, 1.0, 1.0)
	fill_style.set_corner_radius_all(12)
	_progress_bar.add_theme_stylebox_override("fill", fill_style)

	vbox.add_child(_progress_bar)

	# Status label
	_status_label = Label.new()
	_status_label.text = "Connecting..."
	_status_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	var status_settings := LabelSettings.new()
	status_settings.font_size = 28
	status_settings.font_color = Color(0.7, 0.7, 0.8)
	_status_label.label_settings = status_settings
	vbox.add_child(_status_label)

	# Cancel button
	_cancel_button = Button.new()
	_cancel_button.text = "CANCEL"
	_cancel_button.custom_minimum_size = Vector2(300, 70)
	_cancel_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	_cancel_button.pressed.connect(_on_cancel_download)
	vbox.add_child(_cancel_button)

func _show_download_overlay() -> void:
	$VBoxContainer.visible = false
	get_node("OverlayDimmer").visible = true
	_overlay.visible = true
	_progress_bar.value = 0.0
	_status_label.text = "Connecting..."
	_cancel_button.text = "CANCEL"
	_cancel_button.disabled = false
	# Riconnetti cancel al cancel
	if _cancel_button.pressed.is_connected(_on_install_update):
		_cancel_button.pressed.disconnect(_on_install_update)
	if not _cancel_button.pressed.is_connected(_on_cancel_download):
		_cancel_button.pressed.connect(_on_cancel_download)

func _hide_download_overlay() -> void:
	get_node("OverlayDimmer").visible = false
	_overlay.visible = false
	$VBoxContainer.visible = true

func _on_cancel_download() -> void:
	UpdateManager.cancel_download()
	_hide_download_overlay()

## ─── DOWNLOAD CALLBACKS ──────────────────────────────────────

func _on_download_progress(percent: float) -> void:
	if percent >= 0:
		_progress_bar.value = percent
		var size_str: String = UpdateManager.get_download_size_mb()
		_status_label.text = "%.0f%%  (%s)" % [percent, size_str]
	else:
		# Indeterminate — anima la barra
		_progress_bar.value = fmod(Time.get_ticks_msec() / 20.0, 100.0)
		_status_label.text = "Downloading..."

func _on_download_completed(_file_path: String) -> void:
	_progress_bar.value = 100.0
	_status_label.text = "✅ Download completato!"

	# Cambia il bottone Cancel in Install
	_cancel_button.text = "📲 INSTALL"
	if _cancel_button.pressed.is_connected(_on_cancel_download):
		_cancel_button.pressed.disconnect(_on_cancel_download)
	_cancel_button.pressed.connect(_on_install_update)

func _on_download_failed(reason: String) -> void:
	_progress_bar.value = 0.0
	_status_label.text = "❌ %s" % reason

	_cancel_button.text = "CLOSE"
	_cancel_button.disabled = false
	if _cancel_button.pressed.is_connected(_on_cancel_download):
		_cancel_button.pressed.disconnect(_on_cancel_download)
	if _cancel_button.pressed.is_connected(_on_install_update):
		_cancel_button.pressed.disconnect(_on_install_update)
	# Riconnetti per chiudere
	_cancel_button.pressed.connect(_hide_download_overlay)

func _on_install_update() -> void:
	UpdateManager.install_update()

## ─── JUICE & NAVIGATION ─────────────────────────────────────

func _setup_juice() -> void:
	# Pulse title
	var tween := create_tween().set_loops()
	tween.tween_property($Title, "scale", Vector2(1.05, 1.05), 1.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property($Title, "scale", Vector2(1.0, 1.0), 1.5).set_trans(Tween.TRANS_SINE)
	$Title.pivot_offset = $Title.size / 2

	# Button hover effects
	for btn in $VBoxContainer.get_children():
		if btn is Button:
			btn.pivot_offset = btn.size / 2
			if not btn.mouse_entered.is_connected(_on_button_hover.bind(btn)):
				btn.mouse_entered.connect(_on_button_hover.bind(btn))
			if not btn.mouse_exited.is_connected(_on_button_unhover.bind(btn)):
				btn.mouse_exited.connect(_on_button_unhover.bind(btn))

func _on_button_hover(btn: Button) -> void:
	create_tween().tween_property(btn, "scale", Vector2(1.1, 1.1), 0.1).set_trans(Tween.TRANS_BACK)

func _on_button_unhover(btn: Button) -> void:
	create_tween().tween_property(btn, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_BACK)

func _on_play_pressed() -> void:
	TransitionManager.transition_to("res://scenes/levels/main/main.tscn")

func _on_gacha_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/gacha/gacha.tscn")

func _on_slopdex_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/slopdex/slopdex.tscn")

func _on_wardrobe_pressed() -> void:
	TransitionManager.transition_to("res://scenes/ui/wardrobe/wardrobe.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
