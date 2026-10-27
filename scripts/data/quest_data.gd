class_name QuestData
extends Resource

@export var quest_id: String
@export var title: String
@export var description: String
@export var objective_type: String = "Kill"
@export var target_id: String
@export var target_count: int = 1
@export var reward_xp: float = 50.0
@export var reward_gold: int = 20
@export var reward_item: String = ""

const DB := {
	"q_first_step": {
		"title":"初入仙途", "desc":"击败3只野狼妖",
		"type":"Kill", "target":"grunt", "count":3,
		"xp":80.0, "gold":30, "item":"health_pill"
	},
	"q_archer_warning": {
		"title":"暗箭难防", "desc":"消灭4个弓箭手妖",
		"type":"Kill", "target":"archer", "count":4,
		"xp":150.0, "gold":60, "item":"mana_pill"
	},
	"q_spirit_stones": {
		"title":"灵石收集", "desc":"收集20枚灵石",
		"type":"Collect", "target":"spirit_stone", "count":20,
		"xp":100.0, "gold":0, "item":"iron_sword"
	},
	"q_trial": {
		"title":"妖王试炼", "desc":"击败血翼妖王",
		"type":"Kill", "target":"boss_lord", "count":1,
		"xp":800.0, "gold":500, "item":"spiritual_sword"
	},
}

static func all() -> Array:
	var arr := []
	for id in DB.keys():
		arr.append(from_dict(id, DB[id]))
	return arr

static func from_dict(id: String, d: Dictionary) -> QuestData:
	var q := QuestData.new()
	q.quest_id = id
	q.title = d.get("title", id)
	q.description = d.get("desc", "")
	q.objective_type = d.get("type", "Kill")
	q.target_id = d.get("target", "")
	q.target_count = d.get("count", 1)
	q.reward_xp = d.get("xp", 0.0)
	q.reward_gold = d.get("gold", 0)
	q.reward_item = d.get("item", "")
	return q
