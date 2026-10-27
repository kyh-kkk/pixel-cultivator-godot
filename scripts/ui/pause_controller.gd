class_name PauseController
extends Control
@export var resume_btn: Button
@export var save_btn: Button
@export var settings_btn: Button
@export var quit_btn: Button

func _ready() -> void:
	visible = false
	EventBus.toggle_panel.connect(_on_toggle)
	resume_btn.pressed.connect(_on_resume)
	save_btn.pressed.connect(_on_save)
	quit_btn.pressed.connect(_on_quit)

func _on_toggle(name: String) -> void:
	if name != "pause": return
	visible = not visible
	EventBus.game_paused.emit(visible)

func _on_resume() -> void:
	visible = false
	EventBus.game_paused.emit(false)

func _on_save() -> void: SaveManager.save_game()
func _on_quit() -> void: get_tree().quit()
