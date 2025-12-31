extends Node2D

@onready var sprite: Node = $Sprite2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.has_dash = true
		$InteractPopup.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		$InteractPopup.visible = false
