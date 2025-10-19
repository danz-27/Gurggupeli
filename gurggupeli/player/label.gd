extends Label

func _physics_process(_delta: float) -> void:
	text = str(Player.instance.velocity.y, "\n", Player.instance.health.health, "\n", Player.instance.keep_dash_velocity)
