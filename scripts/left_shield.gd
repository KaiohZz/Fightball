extends MeshInstance3D

enum BallOwner { NONE, LEFT, RIGHT }

@export var start_hp := 300.0
@export var min_damage := 2.0
@export var max_damage := 100.0

@onready var ball := $"../../ball"
@onready var body := $LeftShieldCollider/CollisionShape3D
@onready var radio1 := $"../hit"
@onready var radio2 := $"../break"

var hp := start_hp
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
	print("Dono da bola: ", ball.owned_by)
	if ball.owned_by != 2:
		return  # ignora dano
	
	print("HIT NO ESCUDO; Velocidade da Bola: ", ball_speed, "; HP do Escudo: ", hp)
	
	var dmg := remap(ball_speed, 2.0, 100.0, min_damage, max_damage)
	dmg = clamp(dmg, min_damage, max_damage)

	hp -= dmg
	_flash()
	
	$"../../CanvasLayer/leftHealthBar".update()
	radio1.play()
	
	if hp <= 0:
		_destroy()
		radio2.play()

func _process(delta):
	if flash_time > 0:
		flash_time -= delta
		if flash_time <= 0:
			_update_visual()

func _destroy():
	if body:
		body.set_deferred("disabled", true)

	visible = false

func _flash():
	flash_time = 0.08
	$"../../cameraRig".shake(0.5, 0.125)

	if material_override:
		material_override.albedo_color = Color.WHITE

func _update_visual():
	var ratio : float = clamp(hp / start_hp, 0.0, 1.0)
	if material_override:
		material_override.albedo_color = Color(1 - ratio, ratio, 0)

func reset_shield():
	hp = start_hp
	visible = true
	flash_time = 0.0

	if body:
		body.set_deferred("disabled", false)

	_update_visual()
