extends PointLight2D

func _physics_process(_delta: float) -> void:
	position = Player.instance.position
