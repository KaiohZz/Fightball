extends RigidBody3D

@export var base_speed := 8.0
@export var max_speed := 1024.0
@export var min_speed := 2.0
@export var start_position := Vector3.ZERO

var direction := Vector3.DOWN
var speed := base_speed
var frozen := false

func _ready():
	start_position = global_position
	linear_velocity = direction * speed

	contact_monitor = true
	max_contacts_reported = 8
	body_entered.connect(_on_body_entered)

func _physics_process(_delta):
	# NÃO movemos rigidbody aqui
	pass

func _integrate_forces(state):
	if frozen:
		state.linear_velocity = Vector3.ZERO
		return

	if state.linear_velocity.length() > 0.01:
		direction = state.linear_velocity.normalized()
		speed = clamp(state.linear_velocity.length(), min_speed, max_speed)

func _on_body_entered(body):
	if body.has_method("on_ball_hit"):
		body.on_ball_hit(speed)

func apply_kick(new_dir: Vector3, multiplier := 2.0):
	direction = new_dir.normalized()
	speed = clamp(speed * multiplier, min_speed, max_speed)
	linear_velocity = direction * speed

# =============================
# RESET / FREEZE
# =============================

func start_reset(duration: float):
	frozen = true
	freeze = true
	linear_velocity = Vector3.ZERO
	speed = base_speed

	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		start_position,
		duration
	)

func end_reset():
	frozen = false
	freeze = false

	# relança a bola após o reset
	direction = Vector3.RIGHT if randf() > 0.5 else Vector3.LEFT
	linear_velocity = direction * speed
