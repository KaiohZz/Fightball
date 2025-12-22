extends Area3D

@export var goal_side := "RIGHT" 

func _ready():
	connect("body_entered", _on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("ball"):
		print("SCORE:", goal_side)
		get_tree().call_group("game", "on_goal_scored", goal_side)
