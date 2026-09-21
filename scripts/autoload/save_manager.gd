extends Node

signal slots_updated

const SLOT_COUNT := 3
const GAME_MODE_COUNT := 3
const SAVES_PATH := "user://saves/slots.cfg"

var selected_game_mode: int = 1
var selected_slot: int = -1

var _slots_by_mode: Dictionary = {}


func _ready() -> void:
	_init_modes()
	load_slots()


func get_slot(index: int) -> Dictionary:
	return _get_mode_slots(selected_game_mode)[index].duplicate()


func is_slot_empty(index: int) -> bool:
	return bool(_get_mode_slots(selected_game_mode)[index].get("is_empty", true))


func set_selected_game_mode(mode: int) -> void:
	selected_game_mode = mode


func start_new_game(slot_index: int, game_mode: int) -> void:
	selected_slot = slot_index
	selected_game_mode = game_mode

	var slots := _get_mode_slots(game_mode)
	slots[slot_index] = {
		"is_empty": false,
		"display_name": "Save %d" % (slot_index + 1),
		"last_played_unix": Time.get_unix_time_from_system(),
	}
	save_slots()
	slots_updated.emit()
	print("[Save] Nouvelle partie - mode %d, slot %d" % [game_mode, slot_index + 1])


func load_game(slot_index: int) -> void:
	selected_slot = slot_index
	var slot := get_slot(slot_index)
	print(
		"[Save] Chargement - mode %d, slot %d (%s)"
		% [selected_game_mode, slot_index + 1, slot.get("display_name", "")]
	)


func load_slots() -> void:
	_init_modes()

	var config := ConfigFile.new()
	if config.load(SAVES_PATH) != OK:
		return

	for game_mode in range(1, GAME_MODE_COUNT + 1):
		var slots := _get_mode_slots(game_mode)
		for index in SLOT_COUNT:
			var section := _section_name(game_mode, index)
			if not config.has_section(section):
				continue

			slots[index] = {
				"is_empty": bool(config.get_value(section, "is_empty", true)),
				"display_name": str(config.get_value(section, "display_name", "")),
				"last_played_unix": int(config.get_value(section, "last_played_unix", 0)),
			}


func save_slots() -> void:
	var config := ConfigFile.new()

	for game_mode in range(1, GAME_MODE_COUNT + 1):
		var slots := _get_mode_slots(game_mode)
		for index in SLOT_COUNT:
			var section := _section_name(game_mode, index)
			var slot: Dictionary = slots[index]
			config.set_value(section, "is_empty", slot.get("is_empty", true))
			config.set_value(section, "display_name", slot.get("display_name", ""))
			config.set_value(section, "last_played_unix", slot.get("last_played_unix", 0))

	config.save(SAVES_PATH)


func _init_modes() -> void:
	for game_mode in range(1, GAME_MODE_COUNT + 1):
		if not _slots_by_mode.has(game_mode):
			_slots_by_mode[game_mode] = _create_empty_slots()


func _get_mode_slots(game_mode: int) -> Array:
	_init_modes()
	return _slots_by_mode[game_mode]


func _create_empty_slots() -> Array:
	var slots: Array = []
	for _index in SLOT_COUNT:
		slots.append(_empty_slot())
	return slots


func _empty_slot() -> Dictionary:
	return {
		"is_empty": true,
		"display_name": "",
		"last_played_unix": 0,
	}


func _section_name(game_mode: int, slot_index: int) -> String:
	return "mode_%d_slot_%d" % [game_mode, slot_index]
