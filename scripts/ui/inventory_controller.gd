class_name InventoryController
extends Control
@export var item_list: VBoxContainer
@export var gold_label: Label
@export var attr_points_label: Label

func _ready() -> void:
	visible = false
	EventBus.toggle_panel.connect(_on_toggle)
	EventBus.inventory_changed.connect(_refresh)

func _on_toggle(name: String) -> void:
	if name != "inventory": return
	visible = not visible
	EventBus.game_paused.emit(visible)
	if visible: _refresh()

func _refresh() -> void:
	for c in item_list.get_children(): c.queue_free()
	gold_label.text = "灵石: " + str(GameManager.player_gold)
	attr_points_label.text = "可用属性点: " + str(GameManager.attribute_points)
	for item_id in GameManager.inventory.keys():
		var count: int = GameManager.inventory[item_id]
		if count <= 0: continue
		var btn := Button.new()
		btn.text = "%s x%d" % [ItemData.name_of(item_id), count]
		btn.tooltip_text = ItemData.desc_of(item_id)
		btn.pressed.connect(_on_item_pressed.bind(item_id))
		item_list.add_child(btn)

func _on_item_pressed(item_id: String) -> void:
	if ItemData.type_of(item_id) == "Consumable":
		if GameManager.spend_item(item_id, 1):
			var kind := "health" if item_id == "health_pill" else "mana"
			EventBus.potion_used.emit(kind)
