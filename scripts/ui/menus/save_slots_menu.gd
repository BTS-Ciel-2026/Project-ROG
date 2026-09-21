extends Control

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

@onready var title_label: Label = $Margin/VBox/TitleFrame/Title
@onready var slots_row: HBoxContainer = $Margin/VBox/SlotsRow
@onready var back_button: Button = $Margin/VBox/BackButton
@onready var action_panel: PanelContainer = $ActionPanel
@onready var action_title: Label = $ActionPanel/Margin/VBox/ActionTitle
@onready var continue_button: Button = $ActionPanel/Margin/VBox/ContinueButton
@onready var overwrite_button: Button = $ActionPanel/Margin/VBox/OverwriteButton
@onready var cancel_button: Button = $ActionPanel/Margin/VBox/CancelButton

var _slot_buttons: Array[Button] = []
var _pending_slot_index: int = -1


func _ready() -> void:
	_build_slot_buttons()
	_apply_locale()
	_refresh_slots()

	SettingsManager.locale_changed.connect(_apply_locale)
	SaveManager.slots_updated.connect(_refresh_slots)
	back_button.pressed.connect(_on_back_pressed)
	continue_button.pressed.connect(_on_continue_pressed)
	overwrite_button.pressed.connect(_on_overwrite_pressed)
	cancel_button.pressed.connect(_on_cancel_pressed)
	action_panel.visible = false


func _build_slot_buttons() -> void:
	for child in slots_row.get_children():
		child.queue_free()
	_slot_buttons.clear()

	for index in SaveManager.SLOT_COUNT:
		var slot_button := Button.new()
		slot_button.custom_minimum_size = Vector2(220, 280)
		slot_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slot_button.size_flags_vertical = Control.SIZE_EXPAND_FILL
		slot_button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		slot_button.pressed.connect(_on_slot_pressed.bind(index))
		slots_row.add_child(slot_button)
		_slot_buttons.append(slot_button)


func _apply_locale() -> void:
	title_label.text = tr("SAVE_SLOTS_TITLE") % SaveManager.selected_game_mode
	back_button.text = tr("SAVE_SLOTS_BACK")
	action_title.text = tr("SAVE_SLOT_ACTION_TITLE")
	continue_button.text = tr("SAVE_SLOT_CONTINUE")
	overwrite_button.text = tr("SAVE_SLOT_OVERWRITE")
	cancel_button.text = tr("SAVE_SLOT_CANCEL")
	_refresh_slots()


func _refresh_slots() -> void:
	for index in _slot_buttons.size():
		_slot_buttons[index].text = _get_slot_text(index)


func _get_slot_text(slot_index: int) -> String:
	var slot := SaveManager.get_slot(slot_index)
	var slot_label := tr("SAVE_SLOT_LABEL") % (slot_index + 1)

	if slot.get("is_empty", true):
		return "%s\n\n%s\n\n> %s" % [
			slot_label,
			tr("SAVE_SLOT_EMPTY"),
			tr("SAVE_SLOT_NEW"),
		]

	var display_name := str(slot.get("display_name", ""))
	var last_played := _format_timestamp(int(slot.get("last_played_unix", 0)))
	return "%s\n\n%s\n%s\n\n> %s" % [
		slot_label,
		display_name,
		tr("SAVE_SLOT_LAST_PLAYED") % last_played,
		tr("SAVE_SLOT_CONTINUE"),
	]


func _format_timestamp(unix_time: int) -> String:
	if unix_time <= 0:
		return "-"

	return Time.get_datetime_string_from_unix_time(unix_time, false)


func _on_slot_pressed(slot_index: int) -> void:
	if SaveManager.is_slot_empty(slot_index):
		SaveManager.start_new_game(slot_index, SaveManager.selected_game_mode)
		return

	_pending_slot_index = slot_index
	action_title.text = tr("SAVE_SLOT_ACTION_TITLE") % (slot_index + 1)
	action_panel.visible = true


func _on_continue_pressed() -> void:
	if _pending_slot_index < 0:
		return

	SaveManager.load_game(_pending_slot_index)
	_hide_action_panel()


func _on_overwrite_pressed() -> void:
	if _pending_slot_index < 0:
		return

	SaveManager.start_new_game(_pending_slot_index, SaveManager.selected_game_mode)
	_hide_action_panel()


func _on_cancel_pressed() -> void:
	_hide_action_panel()


func _hide_action_panel() -> void:
	_pending_slot_index = -1
	action_panel.visible = false


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
