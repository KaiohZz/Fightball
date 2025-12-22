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

@onready var camera: Camera3D = $Camera3D

func _process(delta):
	if not ball or not player_left or not player_right:
		return

	_update_position(delta)
	_update_zoom(delta)

func _update_position(delta):
	var min_target_x = min(player_left.global_position.x, player_right.global_position.x)
	var max_target_x = max(player_left.global_position.x, player_right.global_position.x)

	var target_x = (min_target_x + max_target_x) * 0.5
	target_x = clamp(target_x, min_x, max_x)

	var pos = global_position
	pos.x = lerp(pos.x, target_x, follow_speed * delta)
	global_position = pos

func _update_zoom(delta):
	var center_x = global_position.x
	var distance = abs(ball.global_position.x - center_x)

	var t = clamp(distance / 6.0, 0.0, 1.0)
	var target_fov = lerp(min_fov, max_fov, t)

	camera.fov = lerp(camera.fov, target_fov, zoom_speed * delta)
	

func _physics_process(_delta):
		global_position.z = 12
