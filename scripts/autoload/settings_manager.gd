extends Node

signal locale_changed
signal settings_changed

const SETTINGS_PATH := "user://settings.cfg"

const LOCALE_FR := "fr"
const LOCALE_EN := "en"

var locale: String = LOCALE_FR
var master_volume: float = 1.0
var music_volume: float = 1.0
var sfx_volume: float = 1.0
var fullscreen: bool = false
var vsync: bool = true
var tutorial_completed: bool = false


func _ready() -> void:
	load_settings()
	_apply_locale()
	_apply_graphics()
	_apply_audio()


func set_locale(new_locale: String) -> void:
	if new_locale == locale:
		return

	locale = new_locale
	_apply_locale()
	save_settings()
	locale_changed.emit()


func set_master_volume(value: float) -> void:
	master_volume = clampf(value, 0.0, 1.0)
	_apply_audio()
	save_settings()
	settings_changed.emit()


func set_music_volume(value: float) -> void:
	music_volume = clampf(value, 0.0, 1.0)
	save_settings()
	settings_changed.emit()


func set_sfx_volume(value: float) -> void:
	sfx_volume = clampf(value, 0.0, 1.0)
	save_settings()
	settings_changed.emit()


func set_fullscreen(enabled: bool) -> void:
	fullscreen = enabled
	_apply_graphics()
	save_settings()
	settings_changed.emit()


func set_vsync(enabled: bool) -> void:
	vsync = enabled
	_apply_graphics()
	save_settings()
	settings_changed.emit()


func has_completed_tutorial() -> bool:
	return tutorial_completed


func mark_tutorial_completed() -> void:
	if tutorial_completed:
		return

	tutorial_completed = true
	save_settings()
	settings_changed.emit()


func load_settings() -> void:
	var config := ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return

	locale = str(config.get_value("settings", "locale", LOCALE_FR))
	master_volume = float(config.get_value("settings", "master_volume", 1.0))
	music_volume = float(config.get_value("settings", "music_volume", 1.0))
	sfx_volume = float(config.get_value("settings", "sfx_volume", 1.0))
	fullscreen = bool(config.get_value("settings", "fullscreen", false))
	vsync = bool(config.get_value("settings", "vsync", true))
	tutorial_completed = bool(
		config.get_value("settings", "tutorial_completed", config.get_value("settings", "demo_completed", false))
	)


func save_settings() -> void:
	var config := ConfigFile.new()
	config.set_value("settings", "locale", locale)
	config.set_value("settings", "master_volume", master_volume)
	config.set_value("settings", "music_volume", music_volume)
	config.set_value("settings", "sfx_volume", sfx_volume)
	config.set_value("settings", "fullscreen", fullscreen)
	config.set_value("settings", "vsync", vsync)
	config.set_value("settings", "tutorial_completed", tutorial_completed)
	config.save(SETTINGS_PATH)


func _apply_locale() -> void:
	TranslationServer.set_locale(locale)


func _apply_graphics() -> void:
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED
	)
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if vsync else DisplayServer.VSYNC_DISABLED
	)


func _apply_audio() -> void:
	var master_index := AudioServer.get_bus_index("Master")
	if master_index >= 0:
		AudioServer.set_bus_volume_db(master_index, linear_to_db(master_volume))
