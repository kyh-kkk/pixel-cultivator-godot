class_name PlayerController
extends CharacterBody2D
@export var data: PlayerData
@export var animation: AnimatedSprite2D
@export var stats: PlayerStats

var facing: int = 1
var can_double_jump: bool = true
var dash_lock: bool = false
var dash_cd_timer: float = 0.0

func _ready() -> void:
	data = data or PlayerData.new()
	floor_snap_length = 8.0

func _physics_process(delta: float) -> void:
	if dash_lock:
		velocity.x = facing * data.dash_speed
		move_and_slide()
		return

	var dir := Input.get_axis("move_left", "move_right")
	velocity.x = dir * data.move_speed

	if dir != 0:
		facing = sign(dir)
		if animation: animation.flip_h = facing < 0

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = data.jump_velocity
		can_double_jump = true
	elif Input.is_action_just_pressed("jump") and can_double_jump:
		velocity.y = data.jump_velocity * 0.85
		can_double_jump = false

	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0 and stats.spend_stamina(25.0):
		_start_dash()

	dash_cd_timer = max(0.0, dash_cd_timer - delta)
	velocity.y += get_gravity() * delta
	move_and_slide()
	_update_anim_state(dir)

func _start_dash() -> void:
	dash_lock = true
	dash_cd_timer = data.dash_cooldown
	var t := get_tree().create_timer(data.dash_duration)
	t.timeout.connect(func(): dash_lock = false)

func _update_anim_state(dir: float) -> void:
	if not animation: return
	if not is_on_floor():
		animation.play("jump")
	elif abs(dir) > 0.1:
		animation.play("run")
	else:
		animation.play("idle")
