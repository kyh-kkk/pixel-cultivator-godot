class_name GameWorld
extends Node2D
@export var player_scene: PackedScene
@export var hud_scene: PackedScene
var loot_dropper: LootDropper

func _ready() -> void:
	if player_scene:
		var p := player_scene.instantiate()
		p.add_to_group("player")
		add_child(p)
	if hud_scene:
		add_child(hud_scene.instantiate())
	loot_dropper = LootDropper.new()
	add_child(loot_dropper)
	EventBus.music_requested.emit("battle_bgm")
