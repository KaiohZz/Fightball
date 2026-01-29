extends Node3D

@onready var ball := $ball
@onready var camera := $cameraRig
@onready var canvas := $CanvasLayer
@onready var speedLabel :=$CanvasLayer/speed_score/speedometer
@onready var score_radio := $score
@onready var goal_radio := $goal

@export var reset_duration := 1
@export var goal_freeze_time := 1

var resetting := false
var score_left := 0
var score_right := 0

var speed_shake_strength := 0.0
var speed_shake_time := 0.0
var speed_original_pos := Vector2.ZERO
var speed_shaking := false

func _ready() -> void:
	speed_original_pos = speedLabel.position
	$"CanvasLayer/Pause Menu".resume()

func _process(delta: float) -> void:
	if ball.speed > 100:
		speedLabel.modulate = Color.RED

		if not speed_shaking:
			speed_shaking = true
			speed_shake_strength = 1.0
			speed_shake_time = 0.0
	else:
		speedLabel.modulate = Color.WHITE
		speed_shaking = false
		speedLabel.position = speed_original_pos

	if speed_shaking:
		speed_label_shake(delta)

func on_goal_scored(side):
	if resetting:
		return

	resetting = true
	
	camera.shake(1.5, 1.0)
	
	if side == "LEFT":
		score_right += 1
		canvas.score_pop($CanvasLayer/speed_score/scoreRight)
		canvas.show_goal("RIGHT")
	else:
		score_left += 1
		canvas.score_pop($CanvasLayer/speed_score/scoreLeft)
		canvas.show_goal("LEFT")
	
	score_radio.play()
	goal_radio.play()
	print("PLACAR:", score_left, "x", score_right)

	await _goal_freeze()
	await _slide_to_start()
	_end_reset()

func _goal_freeze():
	print("Iniciando Freeze")

	get_tree().call_group("players", "set_frozen", true)
	get_tree().call_group("ball", "set_frozen", true)

	await get_tree().create_timer(goal_freeze_time).timeout

	get_tree().call_group("players", "set_frozen", false)
	get_tree().call_group("ball", "set_frozen", false)


func _slide_to_start():
	print("Iniciando Slide")
	
	get_tree().call_group("ball", "reset_owned_by")
	get_tree().call_group("players", "start_reset", reset_duration)
	get_tree().call_group("ball", "start_reset", reset_duration)

	await get_tree().create_timer(reset_duration).timeout


func _end_reset():
	print("Fim do Reset")

	get_tree().call_group("players", "end_reset")
	get_tree().call_group("ball", "end_reset")
	get_tree().call_group("shields", "reset_shield")
	$CanvasLayer/leftHealthBar.update()
	$CanvasLayer/rightHealthBar.update()

	resetting = false

func hit_stop_local(duration: float, kicker):
	# congela bola
	var ball = get_tree().get_nodes_in_group("ball")[0]
	ball.set_frozen(true)

	# congela apenas quem chutou
	if kicker and kicker.has_method("set_frozen"):
		kicker.set_frozen(true)

	await get_tree().create_timer(duration).timeout

	ball.set_frozen(false)

	if kicker and kicker.has_method("set_frozen"):
		kicker.set_frozen(false)

func speed_label_shake(delta):
	speed_shake_time += delta * 40.0
	speed_shake_strength = max(0.0, speed_shake_strength - 20.0 * delta)

	var x := sin(speed_shake_time) * speed_shake_strength
	var y := cos(speed_shake_time * 1.3) * speed_shake_strength

	speedLabel.position = speed_original_pos + Vector2(x, y)
