class_name QuestManager
extends Node
var active_quests: Dictionary = {}

func _ready() -> void:
	EventBus.enemy_died.connect(_on_enemy_killed)
	EventBus.item_collected.connect(_on_item_collected)
	auto_accept("q_first_step")

func auto_accept(quest_id: String) -> void:
	if GameManager.completed_quests.has(quest_id): return
	if GameManager.unlocked_quests.has(quest_id): return
	var q := QuestData.from_dict(quest_id, QuestData.DB[quest_id])
	active_quests[quest_id] = {"data": q, "progress": 0}
	GameManager.unlocked_quests.append(quest_id)
	EventBus.quest_updated.emit(quest_id, 0, q.target_count)
	EventBus.notification_raised.emit("接取任务：" + q.title, 2.5)

func _on_enemy_killed(enemy: Node, _pos: Vector2) -> void:
	var eid: String = enemy.data.enemy_id
	for qid in active_quests.keys():
		var q: Dictionary = active_quests[qid]
		if q.data.objective_type == "Kill" and q.data.target_id == eid:
			_progress(qid, 1)

func _on_item_collected(item_id: String, _count: int) -> void:
	for qid in active_quests.keys():
		var q: Dictionary = active_quests[qid]
		if q.data.objective_type == "Collect" and q.data.target_id == item_id:
			_progress(qid, 1)

func _progress(qid: String, amount: int) -> void:
	var q: Dictionary = active_quests[qid]
	q.progress += amount
	EventBus.quest_updated.emit(qid, q.progress, q.data.target_count)
	if q.progress >= q.data.target_count: _complete(qid)

func _complete(qid: String) -> void:
	var q: Dictionary = active_quests[qid]
	GameManager.add_xp(q.data.reward_xp)
	GameManager.add_gold(q.data.reward_gold)
	if q.data.reward_item != "": GameManager.add_item(q.data.reward_item, 1)
	GameManager.completed_quests.append(qid)
	active_quests.erase(qid)
	EventBus.quest_completed.emit(qid)
	EventBus.notification_raised.emit("任务完成：" + q.data.title, 3.0)
	match qid:
		"q_first_step": auto_accept("q_archer_warning")
		"q_archer_warning": auto_accept("q_spirit_stones")
		"q_spirit_stones": auto_accept("q_trial")

func get_active_quests() -> Array:
	var arr := []
	for qid in active_quests.keys(): arr.append(active_quests[qid])
	return arr
