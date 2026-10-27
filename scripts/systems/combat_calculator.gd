class_name CombatCalculator
extends Node
static func calc_damage(base_atk: float, target_def: float, crit_chance: float) -> Dictionary:
	var raw: float = max(1.0, base_atk - target_def)
	var is_crit: bool = randf() < crit_chance
	if is_crit: raw *= 1.8
	return {"damage": raw, "crit": is_crit}

static func element_modifier(attacker_elem: String, defender_elem: String) -> float:
	var cycle := {"金":"木","木":"土","土":"水","水":"火","火":"金"}
	if cycle.get(attacker_elem, "") == defender_elem: return 1.5
	if cycle.get(defender_elem, "") == attacker_elem: return 0.75
	return 1.0
