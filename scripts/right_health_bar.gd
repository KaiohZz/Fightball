extends TextureProgressBar

@onready var shield:= $"../../goalRight/RightShield"

func _ready():
	update()

func update():
	value = shield.hp * 100 / shield.start_hp
	
