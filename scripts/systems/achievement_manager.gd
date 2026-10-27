class_name AchievementManager
extends Node
func _ready() -> void:
	EventBus.enemy_died.connect(_on_kill)
	EventBus.player_died.connect(_on_death)
	EventBus.realm_breakthrough.connect(_on_breakthrough)
	EventBus.player_gold_changed.connect(_on_gold)

func _on_kill(enemy: Node, _pos: Vector2) -> void:
	unlock("first_blood")
	if GameManager.total_kills >= 100: unlock("killer_100")
	if GameManager.total_kills >= 1000: unlock("killer_1000")
	if enemy.data.ai_type == "Boss": unlock("first_boss")

func _on_death() -> void:
	if GameManager.total_deaths >= 10: unlock("die_hard")

func _on_breakthrough(_realm: String, _lv: int) -> void:
	unlock("breakthrough")

func _on_gold(amount: int) -> void:
	if amount >= 1000: unlock("rich")

func unlock(id: String) -> void:
	if GameManager.unlocked_achievements.has(id): return
	GameManager.unlocked_achievements.append(id)
	var a := AchievementData.DB.get(id, {})
	EventBus.notification_raised.emit("成就解锁：" + a.get("title", id), 3.5)
