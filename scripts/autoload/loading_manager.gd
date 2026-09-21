extends Node

## Gestionnaire de chargement au demarrage.
## Ajouter les chemins lourds dans PRELOAD_PATHS pour activer l'ecran de chargement.

signal loading_finished

const NEXT_SCENE := "res://scenes/main_menu.tscn"

# Ressources a precharger avant le menu. Vide = pas d'ecran de chargement.
const PRELOAD_PATHS: Array[String] = [
	# Exemples pour plus tard :
	# "res://assets/tilesets/dungeon.tres",
	# "res://scenes/game_world.tscn",
]

var _total_count: int = 0
var _completed_count: int = 0
var _current_path: String = ""
var _queue: Array[String] = []
var _is_loading: bool = false
var _cache: Dictionary = {}


func needs_loading() -> bool:
	return not PRELOAD_PATHS.is_empty()


func is_loading() -> bool:
	return _is_loading


func get_current_path() -> String:
	return _current_path


func get_progress() -> float:
	if _total_count == 0:
		return 1.0

	var current_partial := 0.0
	if _current_path != "":
		var progress_array: Array = []
		var status := ResourceLoader.load_threaded_get_status(_current_path, progress_array)
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				if not progress_array.is_empty():
					current_partial = progress_array[0]
			ResourceLoader.THREAD_LOAD_LOADED:
				current_partial = 1.0

	return (_completed_count + current_partial) / float(_total_count)


func get_loaded(path: String) -> Resource:
	return _cache.get(path)


func start_loading() -> void:
	if not needs_loading():
		loading_finished.emit()
		return

	_queue = PRELOAD_PATHS.duplicate()
	_total_count = _queue.size()
	_completed_count = 0
	_current_path = ""
	_is_loading = true
	_start_next()


func poll() -> void:
	if not _is_loading or _current_path == "":
		return

	var status := ResourceLoader.load_threaded_get_status(_current_path)

	match status:
		ResourceLoader.THREAD_LOAD_INVALID_RESOURCE, ResourceLoader.THREAD_LOAD_FAILED:
			push_error("Echec chargement : %s" % _current_path)
			_finish_current()
		ResourceLoader.THREAD_LOAD_LOADED:
			_cache[_current_path] = ResourceLoader.load_threaded_get(_current_path)
			_finish_current()


func _start_next() -> void:
	if _queue.is_empty():
		_is_loading = false
		_current_path = ""
		loading_finished.emit()
		return

	_current_path = _queue.pop_front()
	var error := ResourceLoader.load_threaded_request(_current_path)
	if error != OK:
		push_error("Impossible de lancer le chargement : %s" % _current_path)
		_finish_current()


func _finish_current() -> void:
	_completed_count += 1
	_current_path = ""
	_start_next()
