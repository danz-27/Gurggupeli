extends LightOccluder2D

func _physics_process(_delta: float) -> void:
	if Player.instance.gurggu.flip_h:
		scale.x = -1
	else:
		scale.x = 1
