extends MeshInstance3D

@export var max_hp := 100.0
var hp := max_hp

@export var min_damage := 2.0
@export var max_damage := 100.0

@onready var body := $LeftShieldCollider

var flash_time := 0.0

func _ready():
	if material_override == null:
		var mat := StandardMaterial3D.new()
		mat.albedo_color = Color.GREEN
		material_override = mat
	else:
		mesh.material_override = mesh.material_override.duplicate()

	_update_visual()

func hit(ball_speed: float):
	print("HIT NO ESCUDO; Velocidade da Bola: ", ball_speed, "; HP do Escudo: ", hp)

	var dmg := remap(ball_speed, 2.0, 100.0, min_damage, max_damage)
	dmg = clamp(dmg, min_damage, max_damage)

	hp -= dmg
	_flash()

	if hp <= 0:
		body.collision_layer = 0
		body.collision_mask = 0
		_destroy()

func _process(delta):
	if flash_time > 0:
		flash_time -= delta
		if flash_time <= 0:
			_update_visual()

func _destroy():
	print("ESCUDO DESTRUÍDO - COLISÃO OFF")
	if body:
		body.get_parent().remove_child(body)
		body.queue_free()

	queue_free()

func _flash():
	flash_time = 0.08
	if material_override:
		material_override.albedo_color = Color.WHITE

func _update_visual():
	var ratio : float = clamp(hp / max_hp, 0.0, 1.0)
	if material_override:
		material_override.albedo_color = Color(1 - ratio, ratio, 0)
