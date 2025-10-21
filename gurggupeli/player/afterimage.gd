extends Sprite2D

var fade_speed: float = 3

func _process(delta: float) -> void:
	if self_modulate.a > 0:
		self_modulate.a -= fade_speed * delta
	else:
		queue_free()
