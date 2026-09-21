extends Control

const OPTIONS_SCENE := "res://scenes/options_menu.tscn"

@onready var title_label: Label = $Margin/VBox/TitleFrame/Title
@onready var mode_1_button: Button = $Margin/VBox/ModesRow/Mode1
@onready var mode_2_button: Button = $Margin/VBox/ModesRow/Mode2
@onready var mode_3_button: Button = $Margin/VBox/ModesRow/Mode3
@onready var mode_multi_button: Button = $Margin/VBox/ModesRow/ModeMulti
@onready var option_button: Button = $Margin/VBox/BottomRow/Option
@onready var leave_button: Button = $Margin/VBox/BottomRow/Leave


func _ready() -> void:
	_apply_locale()
	SettingsManager.locale_changed.connect(_apply_locale)


func _apply_locale() -> void:
	title_label.text = tr("TITLE")
	mode_1_button.text = tr("MENU_MODE_1")
	mode_2_button.text = tr("MENU_MODE_2")
	mode_3_button.text = tr("MENU_MODE_3")
	mode_multi_button.text = tr("MENU_MODE_MULTI")
	option_button.text = tr("MENU_OPTION")
	leave_button.text = tr("MENU_LEAVE")


func _on_mode_1_pressed() -> void:
	print("[Menu] Mode de jeu 1 - pas encore implemente")


func _on_mode_2_pressed() -> void:
	print("[Menu] Mode de jeu 2 - pas encore implemente")


func _on_mode_3_pressed() -> void:
	print("[Menu] Mode de jeu 3 - pas encore implemente")


func _on_mode_multi_pressed() -> void:
	print("[Menu] Mode Multijoueur - pas encore implemente")


func _on_option_pressed() -> void:
	get_tree().change_scene_to_file(OPTIONS_SCENE)


func _on_leave_pressed() -> void:
	get_tree().quit()
