extends Label

func _physics_process(_delta: float) -> void:
	text = str(Player.instance.global_position, "\n", Player.instance.health.health, "\n", Player.instance.is_on_floor())
