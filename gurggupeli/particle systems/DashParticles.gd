extends GPUParticles2D

func _physics_process(_delta: float) -> void:
	global_position = Player.instance.global_position
	if Player.instance.is_dashing():
		emitting = true
	else:
		emitting = false
