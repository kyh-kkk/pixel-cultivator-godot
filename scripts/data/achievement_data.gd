class_name AchievementData
extends Resource

@export var achievement_id: String
@export var title: String
@export var description: String
@export var hidden: bool = false

const DB := {
	"first_blood":  {"title":"初战告捷","desc":"击败第一只敌人"},
	"killer_100":   {"title":"百人斩","desc":"累计击败100个敌人"},
	"killer_1000":  {"title":"千人斩","desc":"累计击败1000个敌人"},
	"first_boss":   {"title":"弑君","desc":"击败第一个Boss"},
	"rich":         {"title":"腰缠万贯","desc":"持有1000灵石"},
	"collector":    {"title":"收藏家","desc":"解锁5个成就"},
	"die_hard":     {"title":"不倒翁","desc":"累计死亡10次"},
	"breakthrough": {"title":"破境","desc":"第一次突破大境界"},
}

static func all() -> Array:
	var arr := []
	for id in DB.keys():
		var a := AchievementData.new()
		a.achievement_id = id
		a.title = DB[id]["title"]
		a.description = DB[id]["desc"]
		arr.append(a)
	return arr
