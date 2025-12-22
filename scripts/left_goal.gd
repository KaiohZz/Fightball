extends Node3D

@onready var goal_area := $LeftGoalArea

func is_open() -> bool:
	return get_tree().get_nodes_in_group("goal_shields").filter(
		func(s): return s.is_inside_tree()
	).is_empty()
