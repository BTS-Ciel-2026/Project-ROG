extends Control

const MAIN_MENU_SCENE := "res://scenes/main_menu.tscn"

@onready var title_label: Label = $Margin/VBox/TitleFrame/Title
@onready var tab_container: TabContainer = $Margin/VBox/TabContainer
@onready var master_slider: HSlider = $Margin/VBox/TabContainer/Audio/AudioVBox/MasterRow/Slider
@onready var music_slider: HSlider = $Margin/VBox/TabContainer/Audio/AudioVBox/MusicRow/Slider
@onready var sfx_slider: HSlider = $Margin/VBox/TabContainer/Audio/AudioVBox/SfxRow/Slider
@onready var master_label: Label = $Margin/VBox/TabContainer/Audio/AudioVBox/MasterRow/Label
@onready var music_label: Label = $Margin/VBox/TabContainer/Audio/AudioVBox/MusicRow/Label
@onready var sfx_label: Label = $Margin/VBox/TabContainer/Audio/AudioVBox/SfxRow/Label
@onready var fullscreen_check: CheckBox = $Margin/VBox/TabContainer/Graphics/GraphicsVBox/FullscreenCheck
@onready var vsync_check: CheckBox = $Margin/VBox/TabContainer/Graphics/GraphicsVBox/VsyncCheck
@onready var language_label: Label = $Margin/VBox/TabContainer/Other/OtherVBox/LanguageRow/Label
@onready var language_option: OptionButton = $Margin/VBox/TabContainer/Other/OtherVBox/LanguageRow/LanguageOption
@onready var back_button: Button = $Margin/VBox/BackButton


func _ready() -> void:
	_setup_language_option()
	_load_values()
	_apply_locale()

	SettingsManager.locale_changed.connect(_apply_locale)
	master_slider.value_changed.connect(_on_master_volume_changed)
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	fullscreen_check.toggled.connect(_on_fullscreen_toggled)
	vsync_check.toggled.connect(_on_vsync_toggled)
	language_option.item_selected.connect(_on_language_selected)
	back_button.pressed.connect(_on_back_pressed)


func _setup_language_option() -> void:
	language_option.clear()
	language_option.add_item("Francais", 0)
	language_option.set_item_metadata(0, SettingsManager.LOCALE_FR)
	language_option.add_item("English", 1)
	language_option.set_item_metadata(1, SettingsManager.LOCALE_EN)


func _load_values() -> void:
	master_slider.value = SettingsManager.master_volume
	music_slider.value = SettingsManager.music_volume
	sfx_slider.value = SettingsManager.sfx_volume
	fullscreen_check.button_pressed = SettingsManager.fullscreen
	vsync_check.button_pressed = SettingsManager.vsync

	for index in language_option.item_count:
		if language_option.get_item_metadata(index) == SettingsManager.locale:
			language_option.select(index)
			break


func _apply_locale() -> void:
	title_label.text = tr("OPTIONS_TITLE")
	tab_container.set_tab_title(0, tr("OPTIONS_TAB_AUDIO"))
	tab_container.set_tab_title(1, tr("OPTIONS_TAB_GRAPHICS"))
	tab_container.set_tab_title(2, tr("OPTIONS_TAB_OTHER"))
	master_label.text = tr("OPTIONS_AUDIO_MASTER")
	music_label.text = tr("OPTIONS_AUDIO_MUSIC")
	sfx_label.text = tr("OPTIONS_AUDIO_SFX")
	fullscreen_check.text = tr("OPTIONS_FULLSCREEN")
	vsync_check.text = tr("OPTIONS_VSYNC")
	language_label.text = tr("OPTIONS_LANGUAGE")
	back_button.text = tr("OPTIONS_BACK")


func _on_master_volume_changed(value: float) -> void:
	SettingsManager.set_master_volume(value)


func _on_music_volume_changed(value: float) -> void:
	SettingsManager.set_music_volume(value)


func _on_sfx_volume_changed(value: float) -> void:
	SettingsManager.set_sfx_volume(value)


func _on_fullscreen_toggled(enabled: bool) -> void:
	SettingsManager.set_fullscreen(enabled)


func _on_vsync_toggled(enabled: bool) -> void:
	SettingsManager.set_vsync(enabled)


func _on_language_selected(index: int) -> void:
	var new_locale: String = language_option.get_item_metadata(index)
	SettingsManager.set_locale(new_locale)


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file(MAIN_MENU_SCENE)
