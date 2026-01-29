extends RigidBody3D

@export var base_speed := 8.0
@export var max_speed := 120
@export var min_speed := 4.0
@export var start_position := Vector3.ZERO

@onready var sprite := $Sprite3D
@onready var tex_neutral := preload("res://assets/sprites/neutralBall.png")
@onready var tex_left := preload("res://assets/sprites/redBall.png")
@onready var tex_right := preload("res://assets/sprites/blueBall.png")
@onready var kick_radio1 := $kick
@onready var bounce_radio := $bounce
@onready var bounce_area: Area3D = $BounceArea

enum BallOwner { NONE, LEFT, RIGHT }
var direction := Vector3.DOWN
var speed := base_speed
var frozen := false
var owned_by := BallOwner.NONE

func _ready():
	bounce_area.body_entered.connect(_on_bounce_area_entered)
	start_position = global_position
	linear_velocity = direction * speed

	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	pass

func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if frozen:
		state.linear_velocity = Vector3.ZERO
		return

	var vel: Vector3 = state.linear_velocity
	var speed_now: float = vel.length()

	if speed_now > 0.01:
		direction = vel.normalized()
		speed = clamp(speed_now, min_speed, max_speed)

func _on_bounce_area_entered(body: Node) -> void:
	print("Contato")
	
	if frozen:
		return

	_play_bounce_sfx()

func _play_bounce_sfx() -> void:
	print("bounce")
	bounce_radio.pitch_scale = randf_range(0.95, 1.05)
	bounce_radio.stop()
	bounce_radio.play()

func _on_body_entered(body):
	if body.has_method("on_ball_hit"):
		body.on_ball_hit(speed)

func apply_kick(new_dir: Vector3, multiplier, kicker_side, kicker):
	kick_radio1.play()
	new_owner(kicker_side)
	print("Chutada por: ", owned_by)
	direction = new_dir.normalized()
	speed = clamp(speed * multiplier, min_speed, max_speed)
	linear_velocity = direction * speed
	
	if speed > 30:
		$"..".hit_stop_local(speed * 0.005, kicker)
		$"../cameraRig".shake(0.125, speed * 0.005)
		

func start_reset(duration: float):
	frozen = true
	freeze = true

	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	speed = base_speed
	direction = Vector3.DOWN

	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		start_position,
		duration
	)

func end_reset():
	# garante que não sobra impulso
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO

	frozen = false
	freeze = false

	# impulso inicial controlado
	linear_velocity = direction * speed

func new_owner(new_owner: BallOwner):
	if owned_by == new_owner:
		return
	
	owned_by = new_owner
	_update_visual_owner()
	print("Dono atualizado. Novo dono: ", owned_by)

func _update_visual_owner():
	sprite.modulate = Color.WHITE

	match owned_by:
		BallOwner.NONE:
			sprite.texture = tex_neutral
		BallOwner.LEFT:
			sprite.texture = tex_left
		BallOwner.RIGHT:
			sprite.texture = tex_right

	sprite.modulate = Color(1, 1, 1, 0)
	var tween := create_tween()
	tween.tween_property(sprite, "modulate:a", 1.0, 0.05)

func reset_owned_by():
	owned_by = BallOwner.NONE
	_update_visual_owner()

func set_frozen(value: bool):
	frozen = value
	freeze = value

	if value:
		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
	else:
		# retoma movimento controlado
		linear_velocity = direction * speed
