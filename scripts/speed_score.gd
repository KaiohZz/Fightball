extends TextureRect

@onready var speed := $speedometer
@onready var scoreL := $scoreLeft
@onready var scoreR := $scoreRight
@onready var referee := $"../.."
@onready var ball := $"../../ball"

func _process(delta: float) -> void:
	speed.text = str(int(ball.speed))
	scoreL.text = str(referee.score_left)
	scoreR.text = str(referee.score_right)
