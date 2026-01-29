extends TextureProgressBar

@onready var shield:= $"../../goalLeft/LeftShield"

func _ready():
	update()

func update():
	value = shield.hp * 100 / shield.start_hp
	
