extends Control

@onready var center: CenterContainer = $Center
@onready var progress_bar: ProgressBar = $Center/VBox/ProgressBar
@onready var status_label: Label = $Center/VBox/StatusLabel


func _ready() -> void:
	if not LoadingManager.needs_loading():
		get_tree().call_deferred("change_scene_to_file", LoadingManager.NEXT_SCENE)
		return

	center.visible = true
	progress_bar.value = 0.0
	status_label.text = tr("LOADING")

	LoadingManager.loading_finished.connect(_on_loading_finished, CONNECT_ONE_SHOT)
	LoadingManager.start_loading()


func _process(_delta: float) -> void:
	if not LoadingManager.is_loading():
		return

	LoadingManager.poll()
	progress_bar.value = LoadingManager.get_progress() * 100.0

	var current_path := LoadingManager.get_current_path()
	if current_path != "":
		status_label.text = current_path.get_file()


func _on_loading_finished() -> void:
	get_tree().call_deferred("change_scene_to_file", LoadingManager.NEXT_SCENE)
