extends Area2D

@onready var checkpoint_position: Vector2 = get_child(0).global_position

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.respawn_pos = checkpoint_position
