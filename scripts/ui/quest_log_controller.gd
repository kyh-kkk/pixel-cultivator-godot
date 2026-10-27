class_name QuestLogController
extends Control
@export var quest_list: VBoxContainer

func _ready() -> void:
	visible = false
	EventBus.toggle_panel.connect(_on_toggle)
	EventBus.quest_updated.connect(_refresh)
	EventBus.quest_completed.connect(_refresh)

func _on_toggle(name: String) -> void:
	if name != "quest_log": return
	visible = not visible
	EventBus.game_paused.emit(visible)
	if visible: _refresh()

func _refresh(_a := null, _b := 0, _c := 0) -> void:
	for c in quest_list.get_children(): c.queue_free()
	for q in QuestManager.get_active_quests():
		var d := q.data
		var l := Label.new()
		l.text = "- %s\n  %s\n  进度: %d/%d" % [d.title, d.description, q.progress, d.target_count]
		l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		quest_list.add_child(l)
	if quest_list.get_child_count() == 0:
		quest_list.add_child(Label.new()).text = "暂无可进行的任务"
