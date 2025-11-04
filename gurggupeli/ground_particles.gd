extends GPUParticles2D

func _physics_process(_delta: float) -> void:
	global_position = Player.instance.global_position + Vector2(0, 7.5)
	if Player.instance.is_on_floor() and Player.instance.velocity.length() > 25 and (Player.instance.gurggu.frame < 19 or Player.instance.gurggu.frame > 22):
		emitting = true
	else:
		emitting = false
