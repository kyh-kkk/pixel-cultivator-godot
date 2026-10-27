class_name PlayerData
extends Resource

@export var base_max_hp: float = 100.0
@export var base_max_mp: float = 50.0
@export var base_max_stamina: float = 100.0
@export var move_speed: float = 280.0
@export var jump_velocity: float = -520.0
@export var dash_speed: float = 700.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 0.8
@export var attack_damage: float = 12.0
@export var attack_range: float = 48.0
@export var attack_cooldown: float = 0.35
@export var crit_chance: float = 0.08

const HP_PER_VIT = 12.0
const MP_PER_SPR = 8.0
const ATK_PER_STR = 2.0
const DEF_PER_END = 1.5
const CRIT_PER_AGI = 0.008

static func derive_max_hp() -> float:
	return PlayerData.base_max_hp + GameManager.attrs.vitality * PlayerData.HP_PER_VIT
static func derive_max_mp() -> float:
	return PlayerData.base_max_mp + GameManager.attrs.spirit * PlayerData.MP_PER_SPR
static func derive_attack() -> float:
	return GameManager.attrs.strength * PlayerData.ATK_PER_STR + 5.0
static func derive_defense() -> float:
	return GameManager.attrs.endurance * PlayerData.DEF_PER_END
static func derive_crit() -> float:
	return PlayerData.crit_chance + GameManager.attrs.agility * PlayerData.CRIT_PER_AGI
