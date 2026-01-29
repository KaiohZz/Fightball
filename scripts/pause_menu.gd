extends Control

func _ready() -> void:
	visible = false

func resume():
	get_tree().paused = false
	visible = false

func pause():
	get_tree().paused = true

func testEsc():
	if Input.is_action_just_pressed("esc") and get_tree().paused:
		resume()
		visible = false
	elif Input.is_action_just_pressed("esc") and not get_tree().paused:
		visible = true
		pause()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("esc"):
		testEsc()

func _on_button_pressed() -> void:
	resume()
	

func _on_button_2_pressed() -> void:
	get_tree().reload_current_scene()

func _on_button_3_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
