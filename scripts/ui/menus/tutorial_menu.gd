extends Control

const MAIN_MENU_SCENE := "res://scenes/ui/menus/main_menu.tscn"

@onready var title_label: Label = $Margin/VBox/TitleFrame/Title
@onready var hint_label: Label = $Margin/VBox/HintLabel
@onready var body_label: Label = $Margin/VBox/BodyPanel/Body
@onready var finish_button: Button = $Margin/VBox/FinishButton
@onready var back_button: Button = $Margin/VBox/BackButton

var _is_mandatory: bool = false


func _ready() -> void:
	_is_mandatory = not SettingsManager.has_completed_tutorial()
	back_button.visible = not _is_mandatory

	_apply_locale()
	SettingsManager.locale_changed.connect(_apply_locale)
	finish_button.pressed.connect(_on_finish_pressed)
	back_button.pressed.connect(_on_back_pressed)


func _apply_locale() -> void:
	title_label.text = tr("TUTORIAL_TITLE")
	hint_label.text = tr("TUTORIAL_MANDATORY_HINT") if _is_mandatory else ""
	hint_label.visible = _is_mandatory
	body_label.text = tr("TUTORIAL_BODY")
	finish_button.text = tr("TUTORIAL_FINISH")
	back_button.text = tr("TUTORIAL_BACK")


func _on_finish_pressed() -> void:
	SettingsManager.mark_tutorial_completed()
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
