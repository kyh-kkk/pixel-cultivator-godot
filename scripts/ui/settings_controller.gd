class_name SettingsController
extends Control
@export var music_slider: HSlider
@export var sfx_slider: HSlider
@export var back_btn: Button

func _ready() -> void:
	visible = false
	music_slider.value_changed.connect(AudioManager.set_music_volume)
	sfx_slider.value_changed.connect(AudioManager.set_sfx_volume)
	back_btn.pressed.connect(func(): visible = false)
