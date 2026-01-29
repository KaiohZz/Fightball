extends Node3D

@export var follow_speed := 5.0
@export var min_x := -8.0
@export var max_x := 8.0
@export var min_fov := 55.0
@export var max_fov := 75.0
@export var zoom_speed := 3.0
@export var ball: RigidBody3D
@export var player_left: CharacterBody3D
@export var player_right: CharacterBody3D
@export var shake_decay := 5.0
@export var shake_frequency := 20.0

@onready var camera: Camera3D = $Camera3D


var shake_timer := 0.0
var shake_strength := 0.0
var shake_offset := Vector3.ZERO
var shake_noise := FastNoiseLite.new()
var shake_time := 0.0
var base_position: Vector3

func _ready():
	base_position = global_position
	shake_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	shake_noise.frequency = 2.0

func _process(delta):
	base_position.z = 12
	
	if not ball or not player_left or not player_right:
		return

	_update_position(delta)
	_update_zoom(delta)
	_update_shake(delta)

	global_position = base_position + shake_offset

func _update_position(delta):
	var min_target_x = min(player_left.global_position.x, player_right.global_position.x)
	var max_target_x = max(player_left.global_position.x, player_right.global_position.x)

	var target_x = (min_target_x + max_target_x) * 0.5
	target_x = clamp(target_x, min_x, max_x)

	base_position.x = lerp(
		base_position.x,
		target_x,
		follow_speed * delta
	)

func _update_zoom(delta):
	var center_x = global_position.x
	var distance = abs(ball.global_position.x - center_x)

	var t = clamp(distance / 6.0, 0.0, 1.0)
	var target_fov = lerp(min_fov, max_fov, t)

	camera.fov = lerp(camera.fov, target_fov, zoom_speed * delta)
	

func _physics_process(_delta):
		global_position.z = 12

func shake(intensity := 0.35, duration := 0.15):
	shake_strength = max(shake_strength, intensity)
	shake_timer = max(shake_timer, duration)

func _update_shake(delta):
	if shake_timer > 0.0:
		shake_timer -= delta
	else:
		shake_strength = max(0.0, shake_strength - shake_decay * delta)

	if shake_strength > 0.0:
		shake_time += delta * shake_frequency

		var x = shake_noise.get_noise_2d(shake_time, 0)
		var y = shake_noise.get_noise_2d(0, shake_time)

		shake_offset = Vector3(x, y, 0) * shake_strength
	else:
		shake_offset = Vector3.ZERO
