extends Node

## Segnali per la UI
signal update_available(version: String, changelog: String)
signal download_progress(percent: float)
signal download_completed(file_path: String)
signal download_failed(reason: String)

## Configurazione
const VERSION_CHECK_URL: String = "https://raw.githubusercontent.com/paolo1234/SlopMerge/main/version.json"
const DOWNLOAD_PATH: String = "user://update.apk"
const CHECK_TIMEOUT: float = 8.0
const DOWNLOAD_TIMEOUT: float = 300.0  # 5 minuti per APK grandi

## Stato
var latest_version: String = ""
var latest_changelog: String = ""
var apk_download_url: String = ""
var is_update_available: bool = false
var is_downloading: bool = false
var _download_request: HTTPRequest = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Controlla aggiornamenti solo su mobile o in release
	call_deferred("_check_for_updates")

## ─── VERSION CHECK ───────────────────────────────────────────

func _check_for_updates() -> void:
	var http := HTTPRequest.new()
	http.name = "VersionChecker"
	add_child(http)
	http.timeout = CHECK_TIMEOUT
	http.request_completed.connect(_on_version_check_completed.bind(http))

	var err := http.request(VERSION_CHECK_URL)
	if err != OK:
		push_warning("UpdateManager: Impossibile avviare version check (err=%d)" % err)
		http.queue_free()

func _on_version_check_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray, http_node: HTTPRequest) -> void:
	http_node.queue_free()

	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		push_warning("UpdateManager: Version check fallito (result=%d, code=%d)" % [result, response_code])
		return

	var json := JSON.new()
	var parse_err := json.parse(body.get_string_from_utf8())
	if parse_err != OK:
		push_warning("UpdateManager: JSON parse error: %s" % json.get_error_message())
		return

	var data = json.data
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("UpdateManager: version.json non è un dizionario valido")
		return

	var remote_version: String = data.get("latest_version", "")
	var remote_apk_url: String = data.get("direct_apk", "")
	var remote_changelog: String = data.get("changelog", "")

	if remote_version == "" or remote_apk_url == "":
		return  # Nessun aggiornamento configurato

	var current_version: String = ProjectSettings.get_setting("application/config/version", "0.0.0")

	if _is_version_greater(remote_version, current_version):
		latest_version = remote_version
		latest_changelog = remote_changelog
		apk_download_url = remote_apk_url
		is_update_available = true
		update_available.emit(latest_version, latest_changelog)

## ─── DOWNLOAD APK ────────────────────────────────────────────

func start_download() -> void:
	if is_downloading:
		push_warning("UpdateManager: Download già in corso")
		return

	if apk_download_url == "":
		download_failed.emit("Nessun URL di download disponibile")
		return

	is_downloading = true

	# Rimuovi file parziale precedente
	if FileAccess.file_exists(DOWNLOAD_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(DOWNLOAD_PATH))

	_download_request = HTTPRequest.new()
	_download_request.name = "APKDownloader"
	_download_request.download_file = DOWNLOAD_PATH
	_download_request.timeout = DOWNLOAD_TIMEOUT
	_download_request.use_threads = true
	add_child(_download_request)
	_download_request.request_completed.connect(_on_download_completed)

	var err := _download_request.request(apk_download_url)
	if err != OK:
		_cleanup_download("Impossibile avviare il download (err=%d)" % err)
		return

func cancel_download() -> void:
	if _download_request and is_downloading:
		_download_request.cancel_request()
		_cleanup_download("Download annullato dall'utente")

func _process(_delta: float) -> void:
	if is_downloading and _download_request:
		var body_size: int = _download_request.get_body_size()
		var downloaded: int = _download_request.get_downloaded_bytes()

		if body_size > 0:
			var percent: float = (float(downloaded) / float(body_size)) * 100.0
			download_progress.emit(percent)
		elif downloaded > 0:
			# Server non ha inviato Content-Length, mostra bytes scaricati
			download_progress.emit(-1.0)  # -1 = indeterminate

func _on_download_completed(result: int, response_code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		var reason: String = "Download fallito (result=%d)" % result
		match result:
			HTTPRequest.RESULT_CANT_CONNECT:
				reason = "Impossibile connettersi al server"
			HTTPRequest.RESULT_CANT_RESOLVE:
				reason = "Impossibile risolvere l'host"
			HTTPRequest.RESULT_CONNECTION_ERROR:
				reason = "Errore di connessione"
			HTTPRequest.RESULT_TLS_HANDSHAKE_ERROR:
				reason = "Errore SSL/TLS"
			HTTPRequest.RESULT_REQUEST_FAILED:
				reason = "Richiesta fallita"
			HTTPRequest.RESULT_TIMEOUT:
				reason = "Timeout — connessione troppo lenta"
		_cleanup_download(reason)
		return

	if response_code != 200:
		_cleanup_download("Server ha risposto con codice %d" % response_code)
		return

	# Verifica che il file esista e abbia dimensione > 0
	if not FileAccess.file_exists(DOWNLOAD_PATH):
		_cleanup_download("File APK non trovato dopo il download")
		return

	var file := FileAccess.open(DOWNLOAD_PATH, FileAccess.READ)
	if file:
		var file_size: int = file.get_length()
		file.close()
		if file_size < 1000:  # APK deve essere almeno qualche KB
			_cleanup_download("File scaricato troppo piccolo (%d bytes) — probabilmente non è un APK valido" % file_size)
			return

	is_downloading = false
	if _download_request:
		_download_request.queue_free()
		_download_request = null

	download_completed.emit(DOWNLOAD_PATH)

func _cleanup_download(reason: String) -> void:
	is_downloading = false
	if _download_request:
		_download_request.queue_free()
		_download_request = null

	# Rimuovi file parziale
	if FileAccess.file_exists(DOWNLOAD_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(DOWNLOAD_PATH))

	download_failed.emit(reason)

## ─── INSTALLAZIONE ───────────────────────────────────────────

func install_update() -> void:
	var global_path: String = ProjectSettings.globalize_path(DOWNLOAD_PATH)

	if not FileAccess.file_exists(DOWNLOAD_PATH):
		push_warning("UpdateManager: APK non trovato in %s" % global_path)
		return

	if OS.get_name() == "Android":
		# Su Android, apri l'APK con il package installer del sistema
		OS.shell_open(global_path)
	else:
		# Su PC, apri la cartella contenente il file
		var dir_path: String = global_path.get_base_dir()
		OS.shell_open(dir_path)

## ─── UTILITY ─────────────────────────────────────────────────

func _is_version_greater(latest: String, current: String) -> bool:
	var l_parts: PackedStringArray = latest.split(".")
	var c_parts: PackedStringArray = current.split(".")

	for i in range(max(l_parts.size(), c_parts.size())):
		var l_val: int = int(l_parts[i]) if i < l_parts.size() else 0
		var c_val: int = int(c_parts[i]) if i < c_parts.size() else 0

		if l_val > c_val:
			return true
		elif l_val < c_val:
			return false
	return false

func get_download_size_mb() -> String:
	if _download_request:
		var body_size: int = _download_request.get_body_size()
		if body_size > 0:
			return "%.1f MB" % (float(body_size) / 1048576.0)
	return "?"
