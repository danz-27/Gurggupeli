extends Label

func _physics_process(_delta: float) -> void:
	text = str(Player.instance.velocity.length(), "\n", Player.instance.health.health, "\n", Player.instance.keep_dash_velocity)
