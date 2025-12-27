extends Label

func _physics_process(_delta: float) -> void:
	text = str(Player.instance.global_position, "\n", Player.instance.animation_player.current_animation, "\n", Player.instance.velocity)
