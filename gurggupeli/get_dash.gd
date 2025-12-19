extends Node2D

@onready var sprite: Node = $Sprite2D

func _ready() -> void:
	if GlobalVariables.has_dash == true:
		sprite.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.has_dash = true
		sprite.visible = false
