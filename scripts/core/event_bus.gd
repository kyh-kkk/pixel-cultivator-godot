class_name EventBus
extends Node
## 全局事件总线 —— 所有跨节点通信都走这里，避免硬引用。
## 任何系统要广播/监听事件，都用 EventBus.xxx.emit() 或 EventBus.xxx.connect()

# ==== 玩家属性变化 ====
signal player_hp_changed(current: float, max: float)
signal player_mp_changed(current: float, max: float)
signal player_stamina_changed(current: float, max: float)
signal player_xp_changed(current: float, needed: float)
signal player_level_changed(new_level: int, realm: String)
signal player_gold_changed(new_amount: int)
signal player_stats_changed()

# ==== 战斗 ====
signal enemy_died(enemy: Node, position: Vector2)
signal player_took_damage(amount: float, source: Node)
signal enemy_took_damage(enemy: Node, amount: float, position: Vector2)
signal player_died()
signal attack_landed(position: Vector2, kind: String)

# ==== 物品 / 背包 ====
signal item_collected(item_id: String, count: int)
signal inventory_changed()
signal equipment_changed()
signal potion_used(kind: String)

# ==== 任务 / 成就 ====
signal quest_updated(quest_id: String, progress: int, target: int)
signal quest_completed(quest_id: String)
signal achievement_unlocked(achievement_id: String)
signal realm_breakthrough(new_realm: String, level: int)

# ==== UI ====
signal open_panel(panel_name: String)
signal close_panel(panel_name: String)
signal toggle_panel(panel_name: String)
signal game_paused(paused: bool)
signal notification_raised(text: String, duration: float)

# ==== 场景 ====
signal scene_transition_requested(scene_path: String, spawn_point: String)
signal level_cleared(level_id: String)

# ==== 音频 ====
signal music_requested(track_name: String)
signal sfx_requested(track_name: String, volume_db: float)
