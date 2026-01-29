extends CharacterBody3D

enum KickType {MID, UP, DOWN}
enum BallOwner { NONE, LEFT, RIGHT }

@export var speed := 15.0
@export var jump_force := 24.0
@export var kick_force := 22.0
@export var debug_kick := true
@onready var mesh: MeshInstance3D = $Visual/MeshInstance3D
@export var start_position := Vector3.ZERO
@export var player_owner: BallOwner = BallOwner.RIGHT
@export var input_prefix := "p2_"
@export var base_color := Color.BLUE
@export var initial_facing := -1

var kick_timer := 0.0
var can_kick := true
var gravity : float = 6 * ProjectSettings.get_setting("physics/3d/default_gravity")
var facing := 1   # 1 = direita, -1 = esquerda
var frozen := false

func _ready():
	start_position = global_position
	facing = initial_facing
	$Visual.scale.x = facing

	if mesh.material_override == null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = base_color
		mesh.material_override = mat

func _physics_process(delta):
	if frozen:
		velocity = Vector3.ZERO
		move_and_slide()
		return
	
	# Movimento horizontal
	var dir := Input.get_axis(input_prefix + "move_left", input_prefix + "move_right")


	if dir != 0:
		facing = sign(dir)
		$Visual.scale.x = facing

	velocity.x = dir * speed

	# Gravidade
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Pulo
	if Input.is_action_just_pressed(input_prefix + "jump"):
		velocity.y = jump_force

	move_and_slide()

func _process(delta):
	$Visual.rotation.z = lerp($Visual.rotation.z, 0.0, 10 * delta)
	
	if kick_timer <= 0:
		can_kick = true
		_set_debug_kicks(false)

	# INPUT DO CHUTE
	if Input.is_action_just_pressed(input_prefix + "kick"):
		kick()

	# FEEDBACK VISUAL
	if kick_timer > 0:
		kick_timer -= delta
		if kick_timer <= 0:
			mesh.material_override.albedo_color = base_color

func _get_kick_type() -> KickType:
	if Input.is_action_pressed(input_prefix + "up"):
		return KickType.UP
	elif Input.is_action_pressed(input_prefix + "down"):
		return KickType.DOWN

	else:
		return KickType.MID

func kick():
	if not can_kick:
		return

	can_kick = false
	kick_timer = 0.5

	var kick_type = _get_kick_type()

	_set_debug_kicks(false)

	match kick_type:
		KickType.MID:
			_set_debug_kick($Visual/KickRoot/KickMid, true)
			_try_kick($Visual/KickRoot/KickMid, Vector3(facing, 0, 0))

		KickType.UP:
			_set_debug_kick($Visual/KickRoot/KickUp, true)
			_try_kick($Visual/KickRoot/KickUp, Vector3(facing, 0.7, 0))

		KickType.DOWN:
			_set_debug_kick($Visual/KickRoot/KickDown, true)
			_try_kick($Visual/KickRoot/KickDown, Vector3(facing, -0.7, 0))

	_visual_kick_feedback(kick_type)


func _try_kick(area: Area3D, direction: Vector3):
	print("Tentando chutar:", area.name)
	for body in area.get_overlapping_bodies():
		print("  Encontrou:", body.name)
		if body.has_method("apply_kick"):
			print("  CHUTE APLICADO")
			body.apply_kick(direction, 2.0, player_owner, $".")

func _visual_kick_feedback(type: KickType):
	kick_timer = 0.3
	
	match type:
		KickType.MID:
			if mesh.material_override:
				mesh.material_override.albedo_color = Color.WHITE
			$Visual.rotation.z = 0

		KickType.UP:
			if mesh.material_override:
				mesh.material_override.albedo_color = Color.CYAN
			$Visual.rotation.z = 1 * facing

		KickType.DOWN:
			if mesh.material_override:
				mesh.material_override.albedo_color = Color.ORANGE
			$Visual.rotation.z = -1 * facing

func _set_debug_kicks(state: bool):
	for kick in $Visual/KickRoot.get_children():
		if kick.has_node("DebugMesh"):
			kick.get_node("DebugMesh").visible = state and debug_kick

func _set_debug_kick(area: Area3D, state: bool):
	if area.has_node("DebugMesh"):
		area.get_node("DebugMesh").visible = state and debug_kick

func set_frozen(value: bool):
	frozen = value
	velocity = Vector3.ZERO

func start_reset(duration: float):
	frozen = true

	var tween := create_tween()
	tween.tween_property(
		self,
		"global_position",
		start_position,
		duration
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func end_reset():
	frozen = false
