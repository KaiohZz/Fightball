extends Node3D

@export var reset_duration := 3
@export var goal_freeze_time := 1

var resetting := false
var score_left := 0
var score_right := 0

func on_goal_scored(side):
	if resetting:
		return

	resetting = true

	if side == "LEFT":
		score_right += 1
	else:
		score_left += 1

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

	get_tree().call_group("players", "start_reset", reset_duration)
	get_tree().call_group("ball", "start_reset", reset_duration)

	await get_tree().create_timer(reset_duration).timeout


func _end_reset():
	print("Fim do Reset")

	get_tree().call_group("players", "end_reset")
	get_tree().call_group("ball", "end_reset")
	get_tree().call_group("shields", "reset_shield")

	resetting = false
