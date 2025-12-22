extends StaticBody3D

@onready var shield := get_parent()

func on_ball_hit(ball_speed: float):
	if shield.has_method("hit"):
		shield.hit(ball_speed)
