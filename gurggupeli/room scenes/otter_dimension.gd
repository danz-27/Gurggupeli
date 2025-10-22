extends Node2D


@onready var camera: Node2D = Player.instance.get_node("Camera2D")

func _physics_process(delta: float) -> void:
	if camera.zoom != Vector2.ZERO:
		camera.zoom = Vector2.ZERO
