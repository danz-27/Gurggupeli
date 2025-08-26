extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var fade_speed: float = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if self_modulate.a > 0:
		self_modulate.a -= fade_speed * delta
	else:
		queue_free()
