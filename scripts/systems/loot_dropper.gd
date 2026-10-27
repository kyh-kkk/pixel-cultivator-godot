class_name LootDropper
extends Node
const DROP_TABLE := {
	"grunt":      [{"id":"spirit_stone","min":1,"max":3,"chance":0.6},{"id":"health_pill","min":1,"max":1,"chance":0.15}],
	"archer":     [{"id":"spirit_stone","min":2,"max":5,"chance":0.7},{"id":"mana_pill","min":1,"max":1,"chance":0.2}],
	"brute":      [{"id":"spirit_stone","min":8,"max":15,"chance":0.9},{"id":"health_pill","min":1,"max":2,"chance":0.5},{"id":"iron_sword","min":1,"max":1,"chance":0.08}],
	"boss_lord":  [{"id":"spirit_stone","min":100,"max":200,"chance":1.0},{"id":"spiritual_sword","min":1,"max":1,"chance":1.0},{"id":"health_pill","min":3,"max":5,"chance":1.0}],
}

func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_died)

func _on_enemy_died(enemy: Node, _pos: Vector2) -> void:
	var eid: String = enemy.data.enemy_id
	var luck: float = GameManager.attrs.luck * 0.02
	var table: Array = DROP_TABLE.get(eid, [])
	for entry in table:
		var chance: float = entry.chance + luck
		if randf() <= chance:
			var count: int = randi_range(entry.min, entry.max)
			GameManager.add_item(entry.id, count)
