extends PanelContainer

@onready var progress_bar: ProgressBar = $VBoxContainer/ProgressBar
@onready var status_label: Label = $VBoxContainer/StatusLabel
@onready var action_button: Button = $VBoxContainer/ActionButton

func _ready() -> void:
	UpdateManager.download_progress.connect(_on_download_progress)
	UpdateManager.download_completed.connect(_on_download_completed)
	UpdateManager.download_failed.connect(_on_download_failed)
	
	action_button.pressed.connect(_on_action_pressed)
	
	_reset_ui()

func _reset_ui() -> void:
	progress_bar.value = 0.0
	status_label.text = "Connecting..."
	action_button.text = "CANCEL"
	action_button.disabled = false

func _on_action_pressed() -> void:
	if action_button.text == "CANCEL":
		UpdateManager.cancel_download()
		queue_free()
	elif action_button.text == "📲 INSTALL":
		UpdateManager.install_update()
	elif action_button.text == "CLOSE":
		queue_free()

func _on_download_progress(percent: float) -> void:
	if percent >= 0:
		progress_bar.value = percent
		var size_str: String = UpdateManager.get_download_size_mb()
		status_label.text = "%.0f%%  (%s)" % [percent, size_str]
	else:
		progress_bar.value = fmod(Time.get_ticks_msec() / 20.0, 100.0)
		status_label.text = "Downloading..."

func _on_download_completed(_file_path: String) -> void:
	progress_bar.value = 100.0
	status_label.text = "✅ Download completato!"
	action_button.text = "📲 INSTALL"

func _on_download_failed(reason: String) -> void:
	progress_bar.value = 0.0
	status_label.text = "❌ %s" % reason
	action_button.text = "CLOSE"
