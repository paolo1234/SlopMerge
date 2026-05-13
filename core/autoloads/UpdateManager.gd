extends Node

signal update_available(version: String, url: String)

var version_check_url: String = "https://raw.githubusercontent.com/paolo1234/SlopMerge/develop/version.json"
var current_update_url: String = ""

func _ready() -> void:
	_check_for_updates()

func _check_for_updates() -> void:
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_on_request_completed)
	
	http_request.timeout = 5.0 # Timeout corto per evitare blocchi
	
	var err = http_request.request(version_check_url)
	if err != OK:
		push_warning("UpdateManager: Impossibile avviare la richiesta HTTP.")

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		return
		
	var json = JSON.new()
	var err = json.parse(body.get_string_from_utf8())
	if err == OK:
		var data = json.data
		if typeof(data) == TYPE_DICTIONARY:
			var latest_version = data.get("latest_version", "")
			var update_url = data.get("direct_apk", "")
			if update_url == "":
				update_url = data.get("url", "") # fallback
				
			var current_version = ProjectSettings.get_setting("application/config/version", "1.7.0")
			
			if latest_version != "" and _is_version_greater(latest_version, current_version):
				current_update_url = update_url
				update_available.emit(latest_version, update_url)

func _is_version_greater(latest: String, current: String) -> bool:
	var l_parts = latest.split(".")
	var c_parts = current.split(".")
	
	for i in range(max(l_parts.size(), c_parts.size())):
		var l_val = int(l_parts[i]) if i < l_parts.size() else 0
		var c_val = int(c_parts[i]) if i < c_parts.size() else 0
		
		if l_val > c_val:
			return true
		elif l_val < c_val:
			return false
	return false

func open_update_url() -> void:
	if current_update_url != "":
		OS.shell_open(current_update_url)
