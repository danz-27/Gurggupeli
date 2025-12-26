extends Node2D

@onready var sprite: Node = $Sprite2D

func _ready() -> void:
	if GlobalVariables.has_crowbar == true:
		sprite.visible = false
	var tween: Tween = get_tree().create_tween()
	tween.set_loops()
	tween.tween_property(sprite, "position", Vector2(0, -5), 3).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(sprite, "position", Vector2(0, 5), 3).set_ease(Tween.EASE_IN_OUT)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		GlobalVariables.has_crowbar = true
		sprite.visible = false
