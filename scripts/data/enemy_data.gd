class_name EnemyData
extends Resource

@export var enemy_id: String = "grunt"
@export var display_name: String = "小妖"
@export var max_hp: float = 40.0
@export var move_speed: float = 90.0
@export var damage: float = 8.0
@export var attack_range: float = 40.0
@export var detect_range: float = 260.0
@export var attack_cooldown: float = 1.2
@export var xp_reward: float = 25.0
@export var gold_reward: int = 10
@export var contact_damage: float = 5.0
@export var ai_type: String = "Melee"

static func preset(id: String) -> EnemyData:
	var d := EnemyData.new()
	match id:
		"grunt":
			d.enemy_id = "grunt"; d.display_name = "野狼妖"
			d.max_hp = 40.0; d.move_speed = 95.0; d.damage = 8.0
			d.attack_range = 36.0; d.detect_range = 240.0
			d.xp_reward = 25.0; d.gold_reward = 8; d.ai_type = "Melee"
		"archer":
			d.enemy_id = "archer"; d.display_name = "弓箭手妖"
			d.max_hp = 28.0; d.move_speed = 60.0; d.damage = 12.0
			d.attack_range = 320.0; d.detect_range = 380.0
			d.xp_reward = 35.0; d.gold_reward = 14; d.ai_type = "Ranged"
		"brute":
			d.enemy_id = "brute"; d.display_name = "妖王亲卫"
			d.max_hp = 120.0; d.move_speed = 70.0; d.damage = 20.0
			d.attack_range = 50.0; d.detect_range = 280.0
			d.xp_reward = 90.0; d.gold_reward = 40; d.ai_type = "Melee"
		"boss_lord":
			d.enemy_id = "boss_lord"; d.display_name = "血翼妖王"
			d.max_hp = 600.0; d.move_speed = 110.0; d.damage = 30.0
			d.attack_range = 70.0; d.detect_range = 600.0
			d.xp_reward = 500.0; d.gold_reward = 500; d.ai_type = "Boss"
	return d
