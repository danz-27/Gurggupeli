extends PointLight2D

func _physics_process(_delta: float) -> void:
	global_position = Camera.instance.global_position
