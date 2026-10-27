class_name SkillTreeController
extends Control
@export var skill_list: VBoxContainer
const SKILL_ORDER := ["sword_qi","fireball","whirlwind","sword_array"]

func _ready() -> void:
	visible = false
	EventBus.toggle_panel.connect(_on_toggle)

func _on_toggle(name: String) -> void:
	if name != "skill_tree": return
	visible = not visible
	EventBus.game_paused.emit(visible)
	if visible: _refresh()

func _refresh() -> void:
	for c in skill_list.get_children(): c.queue_free()
	for sid in SKILL_ORDER:
		var sd := SkillData.of(sid)
		var row := HBoxContainer.new()
		var label := Label.new()
		var locked: bool = GameManager.player_level < sd.required_level
		var owned: bool = GameManager.unlocked_skills.has(sid)
		label.text = "[%s] %s (Lv%d) - %s | 耗蓝%d 冷却%.1fs" % [
			"已学" if owned else ("可学" if not locked else "未解锁"),
			sd.display_name, sd.required_level, sd.description, sd.mana_cost, sd.cooldown]
		row.add_child(label)
		if not owned and not locked:
			var btn := Button.new()
			btn.text = "学习"
			btn.pressed.connect(_on_learn.bind(sid))
			row.add_child(btn)
		skill_list.add_child(row)

func _on_learn(sid: String) -> void:
	GameManager.unlocked_skills.append(sid)
	EventBus.inventory_changed.emit()
	_refresh()
