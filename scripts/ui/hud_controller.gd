class_name HUDController
extends CanvasLayer
@export var hp_bar: ProgressBar
@export var mp_bar: ProgressBar
@export var stamina_bar: ProgressBar
@export var xp_bar: ProgressBar
@export var gold_label: Label
@export var level_label: Label
@export var realm_label: Label
@export var notify_label: Label
var _notify_tween: Tween

func _ready() -> void:
	EventBus.player_hp_changed.connect(_on_hp)
	EventBus.player_mp_changed.connect(_on_mp)
	EventBus.player_xp_changed.connect(_on_xp)
	EventBus.player_level_changed.connect(_on_level)
	EventBus.player_gold_changed.connect(_on_gold)
	EventBus.notification_raised.connect(_notify)
	EventBus.player_stamina_changed.connect(_on_stamina)

func _on_hp(c: float, m: float) -> void: hp_bar.max_value = m; hp_bar.value = c
func _on_mp(c: float, m: float) -> void: mp_bar.max_value = m; mp_bar.value = c
func _on_stamina(c: float, m: float) -> void: stamina_bar.max_value = m; stamina_bar.value = c
func _on_xp(c: float, n: float) -> void: xp_bar.max_value = n; xp_bar.value = c
func _on_level(lv: int, realm: String) -> void: level_label.text = "Lv." + str(lv); realm_label.text = realm
func _on_gold(g: int) -> void: gold_label.text = "灵石: " + str(g)

func _notify(text: String, duration: float) -> void:
	notify_label.text = text
	notify_label.modulate.a = 1.0
	if _notify_tween: _notify_tween.kill()
	_notify_tween = create_tween()
	_notify_tween.tween_interval(duration)
	_notify_tween.tween_property(notify_label, "modulate:a", 0.0, 1.0)

func _process(_d: float) -> void:
	if Input.is_action_just_pressed("inventory"): EventBus.toggle_panel.emit("inventory")
	if Input.is_action_just_pressed("quest_log"): EventBus.toggle_panel.emit("quest_log")
	if Input.is_action_just_pressed("skill_tree"): EventBus.toggle_panel.emit("skill_tree")
	if Input.is_action_just_pressed("pause"): EventBus.toggle_panel.emit("pause")
	if Input.is_action_just_pressed("use_potion"): _use_potion()

func _use_potion() -> void:
	if GameManager.spend_item("health_pill", 1): EventBus.potion_used.emit("health")
	elif GameManager.spend_item("mana_pill", 1): EventBus.potion_used.emit("mana")
	else: EventBus.notification_raised.emit("没有丹药了", 1.5)
