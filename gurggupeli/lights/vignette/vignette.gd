extends PointLight2D

func _physics_process(_delta: float) -> void:
	position = Camera.instance.global_position
