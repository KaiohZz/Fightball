extends CharacterBody3D

@export var base_speed := 8.0
@export var max_speed := 40.0
@export var min_speed := 3.0

var speed := base_speed
var direction := Vector3.UP
var just_bounced := false
var just_kicked := false


func _physics_process(delta):
	if not just_kicked:
		velocity = direction * speed

	move_and_slide()

	if just_kicked:
		just_kicked = false
		return

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var normal = collision.get_normal()

		direction = direction.bounce(normal).normalized()
		velocity = direction * speed
		break

func apply_kick(new_dir: Vector3, multiplier := 2.0):
	direction = new_dir.normalized()
	speed = clamp(speed * multiplier, min_speed, max_speed)
	velocity = direction * speed
	just_kicked = true
