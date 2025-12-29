extends Area2D

@export var offset: Vector2

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Camera.instance.set_camera_offset(offset)
