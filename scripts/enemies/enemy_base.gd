class_name EnemyBase
extends CharacterBody2D
enum State { IDLE, PATROL, CHASE, ATTACK, STUN, DEAD }

@export var data: EnemyData
@export var animation: AnimatedSprite2D
@export var hitbox: Area2D

var state: State = State.IDLE
var current_hp: float
var attack_cd: float = 0.0
var patrol_dir: int = 1
var patrol_origin: Vector2
var player: Node2D

func _ready() -> void:
	data = data or EnemyData.preset("grunt")
	current_hp = data.max_hp
	patrol_origin = global_position
	if hitbox:
		hitbox.area_entered.connect(_on_hitbox_entered)
	EventBus.attack_landed.connect(_on_player_attack_landed)

func _physics_process(delta: float) -> void:
	if state == State.DEAD: return
	attack_cd = max(0.0, attack_cd - delta)
	player = get_tree().get_first_node_in_group("player") as Node2D
	_update_state(delta)
	velocity.y += get_gravity() * delta
	move_and_slide()

func _update_state(delta: float) -> void:
	match state:
		State.IDLE:
			velocity.x = 0
			if animation: animation.play("idle")
			if _dist_to_player() < data.detect_range: state = State.CHASE
		State.PATROL:
			velocity.x = patrol_dir * data.move_speed
			if animation: animation.play("run"); animation.flip_h = patrol_dir < 0
			if abs(global_position.x - patrol_origin.x) > 120: patrol_dir *= -1
			if _dist_to_player() < data.detect_range: state = State.CHASE
		State.CHASE:
			if not player: state = State.PATROL; return
			var dir := sign(player.global_position.x - global_position.x)
			velocity.x = dir * data.move_speed
			if animation: animation.flip_h = dir < 0; animation.play("run")
			if _dist_to_player() < data.attack_range and attack_cd <= 0:
				state = State.ATTACK; attack_cd = data.attack_cooldown
		State.ATTACK:
			velocity.x = 0
			if animation: animation.play("attack")
			var t := get_tree().create_timer(data.attack_cooldown * 0.8)
			t.timeout.connect(func():
				if player and _dist_to_player() < data.attack_range + 20:
					player.take_damage(data.damage, self)
				state = State.CHASE if _dist_to_player() < data.detect_range else State.PATROL
			)

func _dist_to_player() -> float:
	if not player: return INF
	return global_position.distance_to(player.global_position)

func take_damage(amount: float, from_pos: Vector2) -> void:
	if state == State.DEAD: return
	current_hp -= amount
	EventBus.enemy_took_damage.emit(self, amount, global_position)
	velocity = (global_position - from_pos).normalized() * 120
	if current_hp <= 0: _die()
	else:
		state = State.STUN
		var t := get_tree().create_timer(0.25)
		t.timeout.connect(func(): if state != State.DEAD: state = State.CHASE)

func _die() -> void:
	state = State.DEAD
	if animation: animation.play("death")
	GameManager.add_xp(data.xp_reward)
	GameManager.add_gold(data.gold_reward)
	EventBus.enemy_died.emit(self, global_position)
	var t := get_tree().create_timer(0.8)
	t.timeout.connect(queue_free)

func _on_hitbox_entered(_area: Area2D) -> void:
	if player and player.has_method("take_damage"):
		player.take_damage(data.contact_damage, self)

func _on_player_attack_landed(pos: Vector2, kind: String) -> void:
	if kind == "slash" and global_position.distance_to(pos) < data.attack_range + 20:
		var dmg: float = PlayerData.derive_attack()
		if randf() < PlayerData.derive_crit(): dmg *= 1.8
		take_damage(dmg, pos)
