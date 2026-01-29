extends CanvasLayer

@onready var goal_label: Label = $gol

func _ready():
	goal_label.visible = false
	goal_label.rotation = 0
	goal_label.scale = Vector2.ONE

func show_goal(side):
	if side == "LEFT":
		goal_label.modulate = Color.RED
	else:
		goal_label.modulate = Color.BLUE
	
	goal_label.visible = true
	goal_label.rotation = 0
	goal_label.scale = Vector2(0.5, 0.5)
	goal_label.modulate.a = 1.0

	var tween := create_tween()
	tween.set_parallel(true)

	# Rotação contínua
	tween.tween_property(
		goal_label,
		"rotation",
		TAU, # 360 graus
		0.6
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Escala (impacto)
	tween.tween_property(
		goal_label,
		"scale",
		Vector2(1.2, 1.2),
		0.15
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Volta pro tamanho normal
	tween.chain().tween_property(
		goal_label,
		"scale",
		Vector2.ONE,
		0.15
	)

	# Delay + fade out
	tween.chain().tween_interval(0.3)
	tween.chain().tween_property(
		goal_label,
		"modulate:a",
		0.0,
		0.25
	)

	tween.finished.connect(func():
		goal_label.visible = false
	)

func score_pop(label: Label):
	var original_scale := label.scale
	var original_color := label.modulate

	label.modulate = Color.LIME_GREEN
	label.scale = Vector2(1.0, 1.0)

	var tween := create_tween()
	tween.set_parallel(true)

	# POP de escala
	tween.tween_property(
		label,
		"scale",
		Vector2(1.4, 1.4),
		0.12
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Volta ao normal
	tween.chain().tween_property(
		label,
		"scale",
		original_scale,
		0.18
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Volta a cor
	tween.tween_property(
		label,
		"modulate",
		original_color,
		0.25
	)
