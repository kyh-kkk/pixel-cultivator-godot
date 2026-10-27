class_name PlayerStats
extends Node
signal hp_changed(cur: float, max: float)
signal mp_changed(cur: float, max: float)
signal stamina_changed(cur: float, max: float)

var current_hp: float
var current_mp: float
var current_stamina: float
var max_hp: float
var max_mp: float
var max_stamina: float
var invulnerable: float = 0.0

func _ready() -> void:
	recalc_max()
	current_hp = max_hp
	current_mp = max_mp
	current_stamina = max_stamina
	EventBus.player_stats_changed.connect(recalc_max)
	EventBus.potion_used.connect(_on_potion_used)

func recalc_max() -> void:
	max_hp = PlayerData.derive_max_hp()
	max_mp = PlayerData.derive_max_mp()
	max_stamina = 100.0
	current_hp = clamp(current_hp, 0, max_hp)
	current_mp = clamp(current_mp, 0, max_mp)
	current_stamina = clamp(current_stamina, 0, max_stamina)
	_emit_all()

func _process(delta: float) -> void:
	if invulnerable > 0:
		invulnerable -= delta
	current_mp = min(max_mp, current_mp + 3.0 * delta)
	current_stamina = min(max_stamina, current_stamina + 18.0 * delta)
	mp_changed.emit(current_mp, max_mp)
	stamina_changed.emit(current_stamina, max_stamina)

func take_damage(amount: float, source: Node) -> void:
	if invulnerable > 0: return
	var def: float = PlayerData.derive_defense()
	var real: float = max(1.0, amount - def)
	current_hp -= real
	invulnerable = 0.6
	hp_changed.emit(current_hp, max_hp)
	EventBus.player_took_damage.emit(real, source)
	if current_hp <= 0:
		EventBus.player_died.emit()

func spend_stamina(amount: float) -> bool:
	if current_stamina >= amount:
		current_stamina -= amount
		return true
	return false

func spend_mp(amount: float) -> bool:
	if current_mp >= amount:
		current_mp -= amount
		return true
	return false

func heal(amount: float) -> void:
	current_hp = min(max_hp, current_hp + amount)
	hp_changed.emit(current_hp, max_hp)

func _on_potion_used(kind: String) -> void:
	if kind == "health":
		heal(40.0)
	elif kind == "mana":
		current_mp = min(max_mp, current_mp + 25.0)
	mp_changed.emit(current_mp, max_mp)

func _emit_all() -> void:
	hp_changed.emit(current_hp, max_hp)
	mp_changed.emit(current_mp, max_mp)
	stamina_changed.emit(current_stamina, max_stamina)
