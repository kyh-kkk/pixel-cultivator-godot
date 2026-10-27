class_name MainMenu
extends Control
@export var new_game_btn: Button
@export var continue_btn: Button
@export var quit_btn: Button
@export var title_label: Label

func _ready() -> void:
	title_label.text = "像素修仙录"
	continue_btn.disabled = not SaveManager.has_save()
	new_game_btn.pressed.connect(_on_new_game)
	continue_btn.pressed.connect(_on_continue)
	quit_btn.pressed.connect(func(): get_tree().quit())

func _on_new_game() -> void:
	SaveManager.delete_save()
	get_tree().paused = false
	EventBus.scene_transition_requested.emit("res://scenes/main/game_world.tscn", "")

func _on_continue() -> void:
	SaveManager.load_game()
	get_tree().paused = false
	EventBus.scene_transition_requested.emit("res://scenes/main/game_world.tscn", "")
