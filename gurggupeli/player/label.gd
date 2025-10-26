extends Label

func _physics_process(_delta: float) -> void:
	text = str(Player.instance.player_direction, "\n", Player.instance.health.health, "\n", Player.instance.keep_dash_velocity)
