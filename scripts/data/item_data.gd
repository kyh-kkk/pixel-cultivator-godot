class_name ItemData
extends Resource

@export var item_id: String
@export var display_name: String
@export var description: String
@export var type: String = "Consumable"
@export var effect_hp: float = 0.0
@export var effect_mp: float = 0.0
@export var bonus_atk: float = 0.0
@export var bonus_def: float = 0.0

const DB := {
	"health_pill": {"name":"回血丹","desc":"恢复 40 气血","type":"Consumable","hp":40.0},
	"mana_pill":   {"name":"回灵丹","desc":"恢复 25 真元","type":"Consumable","mp":25.0},
	"spirit_stone":{"name":"灵石","desc":"通用货币","type":"Currency"},
	"wooden_sword":{"name":"桃木剑","desc":"攻击 +5","type":"Weapon","atk":5.0},
	"iron_sword":  {"name":"精钢剑","desc":"攻击 +12","type":"Weapon","atk":12.0},
	"spiritual_sword":{"name":"青锋宝剑","desc":"攻击 +25","type":"Weapon","atk":25.0},
	"cloth_robe":  {"name":"布衣","desc":"防御 +3","type":"Armor","def":3.0},
	"leather_armor":{"name":"皮甲","desc":"防御 +8","type":"Armor","def":8.0},
	"talisman":    {"name":"护身符","desc":"幸运 +5","type":"Relic"},
}

static func name_of(id: String) -> String:
	return DB.get(id, {}).get("name", id)
static func desc_of(id: String) -> String:
	return DB.get(id, {}).get("desc", "")
static func type_of(id: String) -> String:
	return DB.get(id, {}).get("type", "Consumable")
