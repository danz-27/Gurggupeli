extends GPUParticles2D

func _activate() -> void:
	emitting = true
	
func _deactivate() -> void:
	emitting = false
