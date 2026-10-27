class_name SkillData
extends Resource

@export var skill_id: String
@export var display_name: String
@export var description: String
@export var mana_cost: float = 10.0
@export var cooldown: float = 3.0
@export var damage_mult: float = 1.5
@export var range: float = 120.0
@export var skill_type: String = "Projectile"
@export var required_level: int = 1

const DB := {
	"slash":       {"name":"挥剑","desc":"基础近战","mp":0,"cd":0.35,"mult":1.0,"lv":1},
	"sword_qi":    {"name":"剑气","desc":"发射远程剑气","mp":12,"cd":1.5,"mult":1.4,"lv":2},
	"fireball":    {"name":"火球术","desc":"范围爆裂火焰","mp":25,"cd":4.0,"mult":2.2,"lv":4},
	"sword_array": {"name":"万剑归宗","desc":"大范围剑阵","mp":50,"cd":10.0,"mult":4.0,"lv":7},
	"whirlwind":   {"name":"旋身斩","desc":"旋转击退周围敌人","mp":18,"cd":3.0,"mult":1.8,"lv":5},
}

static func of(id: String) -> SkillData:
	var d := SkillData.new()
	d.skill_id = id
	var data: Dictionary = DB.get(id, {})
	d.display_name = data.get("name", id)
	d.description = data.get("desc", "")
	d.mana_cost = data.get("mp", 0.0)
	d.cooldown = data.get("cd", 1.0)
	d.damage_mult = data.get("mult", 1.0)
	d.required_level = data.get("lv", 1)
	return d
