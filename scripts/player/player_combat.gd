class_name PlayerCombat
extends Node2D
@export var controller: PlayerController
@export var stats: PlayerStats
@export var attack_hurtbox: Area2D

var _attack_cd: float = 0.0
var _skill_cds := {}

func _ready() -> void:
	if attack_hurtbox:
		attack_hurtbox.monitoring = false

func _physics_process(delta: float) -> void:
	_attack_cd = max(0.0, _attack_cd - delta)
	for k in _skill_cds.keys():
		_skill_cds[k] = max(0.0, _skill_cds[k] - delta)

	if Input.is_action_just_pressed("attack"): try_attack()
	if Input.is_action_just_pressed("skill_1"): cast_skill("sword_qi")
	if Input.is_action_just_pressed("skill_2"): cast_skill("fireball")
	if Input.is_action_just_pressed("skill_3"): cast_skill("sword_array")

func try_attack() -> void:
	if _attack_cd > 0: return
	var sd := SkillData.of("slash")
	_attack_cd = sd.cooldown
	if attack_hurtbox:
		attack_hurtbox.monitoring = true
		var t := get_tree().create_timer(0.12)
		t.timeout.connect(func(): attack_hurtbox.monitoring = false)
	EventBus.attack_landed.emit(global_position + Vector2(controller.facing * 30, 0), "slash")

func cast_skill(skill_id: String) -> void:
	if not GameManager.unlocked_skills.has(skill_id): return
	if GameManager.player_level < SkillData.of(skill_id).required_level: return
	if _skill_cds.get(skill_id, 0.0) > 0: return
	var sd := SkillData.of(skill_id)
	if not stats.spend_mp(sd.mana_cost):
		EventBus.notification_raised.emit("真元不足", 1.0)
		return
	_skill_cds[skill_id] = sd.cooldown
	EventBus.attack_landed.emit(global_position + Vector2(controller.facing * 40, 0), "skill_" + skill_id)

func unlock_skill(skill_id: String) -> bool:
	if GameManager.unlocked_skills.has(skill_id): return false
	var sd := SkillData.of(skill_id)
	if GameManager.player_level < sd.required_level: return false
	GameManager.unlocked_skills.append(skill_id)
	EventBus.notification_raised.emit("解锁技能：" + sd.display_name, 2.5)
	return true

func get_cd_ratio(skill_id: String) -> float:
	var total: float = SkillData.of(skill_id).cooldown
	if total <= 0: return 0.0
	return _skill_cds.get(skill_id, 0.0) / total
